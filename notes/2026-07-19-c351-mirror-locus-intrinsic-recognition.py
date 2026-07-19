#!/usr/bin/env python3
"""Exact bounded obstruction certificate for C351 intrinsic recognition."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import tempfile
from itertools import combinations, permutations
from pathlib import Path


STEM = "2026-07-19-c351-mirror-locus-intrinsic-recognition"
SCHEMA = "c351-intrinsic-recognition-obstruction-v1"
ROOT = Path(__file__).resolve().parent
C333_PATH = ROOT / "2026-07-18-c333-all-odd-q-mirror-locus.py"
C350_PATH = ROOT / "2026-07-19-c350-full-mirror-locus-quotient-count.py"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C333 = load_module("c333_mirror_locus", C333_PATH)
C350 = load_module("c350_mirror_quotient", C350_PATH)


def passing_parameters(field):
    four = field.constant(4)
    for delta in range(field.q):
        if field.character(delta) != -1 or field.character(field.sub(delta, four)) != 1:
            continue
        for b in range(field.q):
            if C333.admissible(field, delta, b):
                yield delta, b


def residual_matrix(field, delta: int, b: int):
    centre_points = tuple((r, c, field.constant(1)) for r, c in C333.centres(field, delta, b))
    generators = [C333.sigma(field, centre) for centre in C333.centres(field, delta, b)]
    dead = set()
    for left, right in combinations(centre_points, 2):
        for value in range(field.q + 1):
            if C333.det3(field, (left, right, C333.conic_point(field, value))) == 0:
                dead.add(value)
    live = sorted(set(range(field.q + 1)) - dead)
    index = {value: i for i, value in enumerate(live)}
    matrix = [[0] * len(live) for _ in live]
    for value in live:
        for generator in generators:
            image = C333.act(field, generator, value)
            if image in index and image != value:
                matrix[index[value]][index[image]] = 1
    return live, matrix


def repair_matrix(field, delta: int, b: int):
    generators = [C333.sigma(field, centre) for centre in C333.centres(field, delta, b)]
    size = field.q + 1
    matrix = [[0] * size for _ in range(size)]
    for generator in generators:
        for value in range(size):
            image = C333.act(field, generator, value)
            if value < image:
                matrix[value][image] += 1
                matrix[image][value] += 1
    return matrix


def vertex_fingerprint(matrix, vertex: int):
    row = matrix[vertex]
    return sum(row), tuple(sorted(row))


def find_isomorphism(left, right):
    if len(left) != len(right):
        return None
    size = len(left)
    left_fingerprints = [vertex_fingerprint(left, i) for i in range(size)]
    right_fingerprints = [vertex_fingerprint(right, i) for i in range(size)]
    if sorted(left_fingerprints) != sorted(right_fingerprints):
        return None
    candidates = {
        i: [j for j in range(size) if right_fingerprints[j] == left_fingerprints[i]]
        for i in range(size)
    }
    order = sorted(range(size), key=lambda i: (len(candidates[i]), left_fingerprints[i], i))
    image: dict[int, int] = {}
    used: set[int] = set()

    def extend(depth: int):
        if depth == size:
            return tuple(image[i] for i in range(size))
        source = order[depth]
        for target in candidates[source]:
            if target in used:
                continue
            if not all(left[source][old] == right[target][new] for old, new in image.items()):
                continue
            image[source] = target
            used.add(target)
            answer = extend(depth + 1)
            if answer is not None:
                return answer
            used.remove(target)
            del image[source]
        return None

    return extend(0)


def verify_isomorphism(left, right, permutation):
    return len(left) == len(right) == len(permutation) and all(
        left[i][j] == right[permutation[i]][permutation[j]]
        for i in range(len(left))
        for j in range(len(left))
    )


def all_automorphisms(matrix):
    size = len(matrix)
    answer = []
    for permutation in permutations(range(size)):
        if all(
            matrix[i][j] == matrix[permutation[i]][permutation[j]]
            for i in range(size)
            for j in range(i + 1, size)
        ):
            answer.append(permutation)
    return answer


def mirror_candidates(matrix):
    return [
        permutation
        for permutation in all_automorphisms(matrix)
        if all(
            permutation[i] != i
            and permutation[permutation[i]] == i
            and matrix[i][permutation[i]] == 0
            for i in range(len(matrix))
        )
    ]


def compose(left, right):
    return tuple(left[right[i]] for i in range(len(left)))


def inverse(permutation):
    answer = [0] * len(permutation)
    for i, value in enumerate(permutation):
        answer[value] = i
    return tuple(answer)


def candidate_class_count(matrix):
    group = all_automorphisms(matrix)
    remaining = set(mirror_candidates(matrix))
    count = 0
    while remaining:
        representative = min(remaining)
        orbit = {
            compose(compose(element, representative), inverse(element))
            for element in group
        }
        remaining -= orbit
        count += 1
    return count


def code_points(field, delta: int, b: int):
    one = field.constant(1)
    return [(one, 0, 0), (0, one, 0)] + [
        (r, c, one) for r, c in C333.centres(field, delta, b)
    ]


def matrix_determinant(field, matrix):
    positive = field.add(
        field.add(
            field.mul(matrix[0][0], field.mul(matrix[1][1], matrix[2][2])),
            field.mul(matrix[0][1], field.mul(matrix[1][2], matrix[2][0])),
        ),
        field.mul(matrix[0][2], field.mul(matrix[1][0], matrix[2][1])),
    )
    negative = field.add(
        field.add(
            field.mul(matrix[0][2], field.mul(matrix[1][1], matrix[2][0])),
            field.mul(matrix[0][1], field.mul(matrix[1][0], matrix[2][2])),
        ),
        field.mul(matrix[0][0], field.mul(matrix[1][2], matrix[2][1])),
    )
    return field.sub(positive, negative)


def matrix_inverse(field, matrix):
    determinant = matrix_determinant(field, matrix)
    assert determinant
    answer = [[0] * 3 for _ in range(3)]
    for i in range(3):
        for j in range(3):
            rows = [row for row in range(3) if row != j]
            columns = [column for column in range(3) if column != i]
            minor = field.sub(
                field.mul(matrix[rows[0]][columns[0]], matrix[rows[1]][columns[1]]),
                field.mul(matrix[rows[0]][columns[1]], matrix[rows[1]][columns[0]]),
            )
            cofactor = minor if (i + j) % 2 == 0 else field.neg(minor)
            answer[i][j] = field.div(cofactor, determinant)
    return answer


def matrix_multiply(field, left, right):
    return [
        [
            sum((field.mul(left[i][k], right[k][j]) for k in range(3)), 0) % field.q
            for j in range(3)
        ]
        for i in range(3)
    ]


def matrix_vector(field, matrix, vector):
    return tuple(
        sum((field.mul(matrix[i][k], vector[k]) for k in range(3)), 0) % field.q
        for i in range(3)
    )


def normalize_point(field, point):
    scale = field.inverse(next(coordinate for coordinate in point if coordinate))
    return tuple(field.mul(scale, coordinate) for coordinate in point)


def columns(points):
    return [[points[column][row] for column in range(3)] for row in range(3)]


def projective_equivalence_witness(field, left, right):
    source_basis = columns(left[:3])
    source_inverse = matrix_inverse(field, source_basis)
    source_fourth = matrix_vector(field, source_inverse, left[3])
    assert all(source_fourth)
    right_set = {normalize_point(field, point) for point in right}
    for target in permutations(right, 4):
        target_basis = columns(target[:3])
        target_inverse = matrix_inverse(field, target_basis)
        target_fourth = matrix_vector(field, target_inverse, target[3])
        if not all(target_fourth):
            continue
        diagonal = [[0] * 3 for _ in range(3)]
        for i in range(3):
            diagonal[i][i] = field.div(target_fourth[i], source_fourth[i])
        witness = matrix_multiply(
            field,
            matrix_multiply(field, target_basis, diagonal),
            source_inverse,
        )
        image = {normalize_point(field, matrix_vector(field, witness, point)) for point in left}
        if image == right_set:
            return witness
    return None


def marked_configuration(field, delta: int, b: int):
    centres = C333.centres(field, delta, b)
    configuration = tuple(
        sorted(
            (
                C350.canonical_centre_orbit(field, delta, centres[0]),
                C350.canonical_centre_orbit(field, delta, centres[2]),
            )
        )
    )
    return configuration


def pair_scan(q: int):
    field = C333.FiniteField(q, 1)
    parameters = list(passing_parameters(field))
    objects = {}
    for parameter in parameters:
        delta, b = parameter
        live, residual = residual_matrix(field, delta, b)
        objects[parameter] = {
            "code": code_points(field, delta, b),
            "live": live,
            "repair": repair_matrix(field, delta, b),
            "residual": residual,
        }
    collision_sets = {"code": set(), "repair": set(), "residual": set()}
    for left, right in combinations(parameters, 2):
        if find_isomorphism(objects[left]["residual"], objects[right]["residual"]) is not None:
            collision_sets["residual"].add((left, right))
        if find_isomorphism(objects[left]["repair"], objects[right]["repair"]) is not None:
            collision_sets["repair"].add((left, right))
        if projective_equivalence_witness(field, objects[left]["code"], objects[right]["code"]) is not None:
            collision_sets["code"].add((left, right))
    common = set.intersection(*collision_sets.values())
    return field, parameters, objects, collision_sets, common


def collision_certificate(field, objects, left, right):
    assert left[0] == right[0]
    delta = left[0]
    left_configuration = marked_configuration(field, *left)
    right_configuration = marked_configuration(field, *right)
    left_canonical = C350.canonical_configuration(field, delta, left_configuration)
    right_canonical = C350.canonical_configuration(field, delta, right_configuration)
    assert left_canonical != right_canonical
    residual_witness = find_isomorphism(objects[left]["residual"], objects[right]["residual"])
    repair_witness = find_isomorphism(objects[left]["repair"], objects[right]["repair"])
    code_witness = projective_equivalence_witness(field, objects[left]["code"], objects[right]["code"])
    assert residual_witness is not None and repair_witness is not None and code_witness is not None
    assert verify_isomorphism(objects[left]["residual"], objects[right]["residual"], residual_witness)
    assert verify_isomorphism(objects[left]["repair"], objects[right]["repair"], repair_witness)
    assert {
        normalize_point(field, matrix_vector(field, code_witness, point))
        for point in objects[left]["code"]
    } == {normalize_point(field, point) for point in objects[right]["code"]}
    left_enhanced = left_configuration == C350.negate_configuration(field, delta, left_configuration)
    right_enhanced = right_configuration == C350.negate_configuration(field, delta, right_configuration)
    assert not left_enhanced and not right_enhanced
    left_order = C350.generated_order(field, left_configuration)
    right_order = C350.generated_order(field, right_configuration)
    assert left_order == right_order == field.q * (field.q * field.q - 1)
    return {
        "code_projectivity_matrix": code_witness,
        "determinant_sheet": C350.configuration_sheet(field, left_configuration),
        "full_group_order": left_order,
        "left": list(left),
        "left_canonical_marked_configuration": left_canonical,
        "left_live_vertices": objects[left]["live"],
        "marked_stabilizer_stratum": "generic <tau>",
        "repair_vertex_permutation": repair_witness,
        "residual_vertex_permutation": residual_witness,
        "right": list(right),
        "right_canonical_marked_configuration": right_canonical,
        "right_live_vertices": objects[right]["live"],
    }


def payload():
    field_rows = []
    scans = {}
    for q in (5, 7, 11, 13):
        field, parameters, objects, collisions, common = pair_scan(q)
        scans[q] = (field, parameters, objects, collisions, common)
        row = {
            "code_collision_pairs": len(collisions["code"]),
            "common_three_interface_collision_pairs": len(common),
            "parameter_count": len(parameters),
            "q": q,
            "repair_collision_pairs": len(collisions["repair"]),
            "residual_collision_pairs": len(collisions["residual"]),
        }
        if q in (5, 7):
            small_rows = []
            for delta, b in parameters:
                residual = objects[(delta, b)]["residual"]
                repair = objects[(delta, b)]["repair"]
                small_rows.append(
                    {
                        "b": b,
                        "delta": delta,
                        "live_vertices": len(objects[(delta, b)]["live"]),
                        "repair_automorphisms": len(all_automorphisms(repair)),
                        "repair_mirror_candidate_classes": candidate_class_count(repair),
                        "repair_mirror_candidates": len(mirror_candidates(repair)),
                        "residual_automorphisms": len(all_automorphisms(residual)),
                        "residual_mirror_candidate_classes": candidate_class_count(residual),
                        "residual_mirror_candidates": len(mirror_candidates(residual)),
                    }
                )
            row["small_field_automorphism_rows"] = small_rows
        field_rows.append(row)
    field, _, objects, _, common = scans[11]
    selected = [((2, 2), (2, 4))]
    assert all(pair in common for pair in selected)
    certificates = [collision_certificate(field, objects, *pair) for pair in selected]
    return {
        "collision_certificates": certificates,
        "conventions": {
            "associated_code": "unmarked projective [6,3,4]_q code on the burned pair and four centres",
            "repair_object": "uncoloured loop-deleted edge-multiplicity union of the four projection matchings on P1(F_q)",
            "residual_graph": "simple union graph on legal conic vertices after deleting every centre-pair secant endpoint",
            "marked_equivalence": "C350 equivalence preserving the conic, burned orbit, and mirror while forgetting centre-orbit order and representatives",
        },
        "field_rows": field_rows,
        "schema": SCHEMA,
    }


def canonical_bytes(data) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def check_tracked(data) -> None:
    tracked = ROOT / f"{STEM}.json"
    expected = canonical_bytes(data)
    assert tracked.read_bytes() == expected, f"stale generated output: {tracked}"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    data = payload()
    if args.check:
        check_tracked(data)
        with tempfile.TemporaryDirectory(prefix="c351-check-") as directory:
            replay = Path(directory) / f"{STEM}.json"
            replay.write_bytes(canonical_bytes(data))
            assert hashlib.sha256(replay.read_bytes()).digest() == hashlib.sha256(
                (ROOT / f"{STEM}.json").read_bytes()
            ).digest()
        print("C351 obstruction certificate: OK")
    else:
        output = args.output or ROOT / f"{STEM}.json"
        output.write_bytes(canonical_bytes(data))
        print(output)


if __name__ == "__main__":
    main()
