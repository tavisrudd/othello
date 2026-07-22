#!/usr/bin/env python3
"""C449/T2: certify the split Coxeter-square torus in PSL_2(q)."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
STEM = "2026-07-21-c449-split-coxeter-torus"
REPORT_PATH = HERE / f"{STEM}.md"
SCRIPT_PATH = HERE / f"{STEM}.py"
REPLAY_PATH = HERE / f"{STEM}-replay.py"
JSON_PATH = HERE / f"{STEM}.json"
SHA_PATH = HERE / f"{STEM}.sha256"
SCHEMA = "c449-split-coxeter-torus-v1"

INPUT_FILES = (
    "2026-07-20-c399-coxeter-number-conic-phase.json",
    "2026-07-20-c399-coxeter-number-conic-phase.md",
    "2026-07-20-c399-coxeter-number-conic-phase.py",
    "2026-07-20-c399-coxeter-number-conic-phase.sha256",
    "2026-07-21-c440-conventions-freeze.json",
    "2026-07-21-c440-conventions-freeze.md",
    "2026-07-21-c440-conventions-freeze.py",
    "2026-07-21-c440-conventions-freeze.sha256",
    "2026-07-21-c441-vertex-reduction-bijection.json",
    "2026-07-21-c441-vertex-reduction-bijection.md",
    "2026-07-21-c441-vertex-reduction-bijection.py",
    "2026-07-21-c441-vertex-reduction-bijection.sha256",
    "2026-07-21-c462-torsor-descent.json",
    "2026-07-21-c462-torsor-descent.md",
)


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C440 = load("c449_c440", HERE / "2026-07-21-c440-conventions-freeze.py")
C441 = load("c449_c441", HERE / "2026-07-21-c441-vertex-reduction-bijection.py")


def file_record(path: Path):
    data = path.read_bytes()
    return {"bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()}


def input_records():
    return {name: file_record(HERE / name) for name in INPUT_FILES}


def canonical_json(value):
    return json.dumps(value, indent=2, sort_keys=True) + "\n"


def permutation_cycles(permutation):
    seen = set()
    answer = []
    for start in range(len(permutation)):
        if start in seen:
            continue
        cycle = []
        point = start
        while point not in seen:
            seen.add(point)
            cycle.append(point)
            point = permutation[point]
        answer.append(cycle)
    return sorted(answer, key=lambda cycle: (len(cycle), cycle))


def permutation_order(permutation):
    answer = 1
    for cycle in permutation_cycles(permutation):
        length = len(cycle)
        candidate = answer
        while candidate % length:
            candidate += answer
        answer = candidate
    return answer


def char0_record(case, data, matrix, source_description):
    operations = data["o"]
    roots = data["roots"]
    index = {point: position for position, point in enumerate(roots)}
    permutation = tuple(
        index[operations["norm_pt"](operations["act"](matrix, point))]
        for point in roots
    )
    assert operations["norm_mat"](matrix) in data["grp"]
    group_permutations = {
        tuple(
            index[operations["norm_pt"](operations["act"](element, point))]
            for point in roots
        )
        for element in data["grp"]
    }

    def compose(left, right):
        return tuple(left[right[position]] for position in range(len(right)))

    centralizer_order = sum(
        compose(element, permutation) == compose(permutation, element)
        for element in group_permutations
    )
    return {
        "case": case,
        "centralizer_order_in_frozen_rotation_group": centralizer_order,
        "conjugacy_class_size_in_frozen_rotation_group": len(group_permutations) // centralizer_order,
        "element_is_in_frozen_rotation_group": True,
        "frozen_rotation_group_order": len(group_permutations),
        "matrix": [[str(coefficient) for coefficient in entry.c] for entry in matrix],
        "order_on_vertices": permutation_order(permutation),
        "permutation_in_frozen_root_order": list(permutation),
        "source": source_description,
        "vertex_cycles_in_frozen_root_order": permutation_cycles(permutation),
    }


def normalize_pgl(matrix, prime):
    pivot = next(value % prime for value in matrix if value % prime)
    inverse = pow(pivot, -1, prime)
    return tuple(value * inverse % prime for value in matrix)


def pgl_product(left, right, prime):
    a, b, c, d = left
    e, f, g, h = right
    return normalize_pgl(
        (a * e + b * g, a * f + b * h, c * e + d * g, c * f + d * h),
        prime,
    )


def pgl_order(matrix, prime):
    identity = (1, 0, 0, 1)
    current = identity
    for order in range(1, prime * (prime * prime - 1) + 1):
        current = pgl_product(matrix, current, prime)
        if current == identity:
            return order
    raise AssertionError("PGL order bound exceeded")


def p1_action(matrix, point, prime):
    a, b, c, d = matrix
    if point == "inf":
        x, y = 1, 0
    else:
        x, y = point, 1
    u = (a * x + b * y) % prime
    v = (c * x + d * y) % prime
    return "inf" if v == 0 else u * pow(v, -1, prime) % prime


def finite_record(case, prime, sheet, matrix, h, expected_blocks):
    matrix = normalize_pgl(matrix, prime)
    determinant = (matrix[0] * matrix[3] - matrix[1] * matrix[2]) % prime
    determinant_is_square = pow(determinant, (prime - 1) // 2, prime) == 1
    order = pgl_order(matrix, prime)
    e = h // 2
    assert order == e == (prime - 1) // 2
    assert determinant_is_square

    points = list(range(prime)) + ["inf"]
    permutation = tuple(points.index(p1_action(matrix, point, prime)) for point in points)
    cycles_as_indices = permutation_cycles(permutation)
    cycles = [[points[index] for index in cycle] for cycle in cycles_as_indices]
    fixed = [cycle[0] for cycle in cycles if len(cycle) == 1]
    moving_orbits = [cycle for cycle in cycles if len(cycle) > 1]
    assert fixed == [0, "inf"]
    assert sorted(len(cycle) for cycle in moving_orbits) == [e, e]
    assert {frozenset(cycle) for cycle in moving_orbits} == {
        frozenset(block) for block in expected_blocks
    }
    squares = {value * value % prime for value in range(1, prime)}
    nonsquares = set(range(1, prime)) - squares
    assert {frozenset(cycle) for cycle in moving_orbits} == {
        frozenset(squares), frozenset(nonsquares)
    }

    diagonal_psl_torus = {
        normalize_pgl((square, 0, 0, 1), prime)
        for square in {value * value % prime for value in range(1, prime)}
    }
    generated = set()
    current = (1, 0, 0, 1)
    for _ in range(order):
        generated.add(current)
        current = pgl_product(matrix, current, prime)
    assert generated == diagonal_psl_torus

    outer_multiplier = min(nonsquares)
    outer_matrix = normalize_pgl((outer_multiplier, 0, 0, 1), prime)
    assert pow(outer_multiplier, (prime - 1) // 2, prime) == prime - 1
    assert {p1_action(outer_matrix, value, prime) for value in squares} == nonsquares
    assert {p1_action(outer_matrix, value, prime) for value in nonsquares} == squares

    return {
        "action_decomposition": {
            "fixed_points": fixed,
            "moving_orbits": moving_orbits,
            "moving_orbits_are_quadratic_residue_cosets": True,
            "moving_point_count": prime - 1,
            "permutation_module_restriction": {
                "formula": "2*trivial + 2*regular(C_e)",
                "invariant_dimension": 4,
                "nontrivial_character_multiplicity": 2,
                "semisimple_when_characteristic_does_not_divide_e": True,
                "trivial_character_multiplicity": 4,
            },
            "summary": f"2 fixed + {prime - 1} moving, refined as 1+1+{e}+{e}",
        },
        "case": case,
        "coxeter_number_h": h,
        "coxeter_square_order": e,
        "determinant_mod_q": determinant,
        "determinant_square": determinant_is_square,
        "generator_matrix_in_frozen_P1_frame": list(matrix),
        "is_generator_of_split_maximal_torus_in_PSL2": generated == diagonal_psl_torus,
        "outer_PGL_over_PSL_coset": {
            "determinant_is_nonsquare": True,
            "matrix": list(outer_matrix),
            "swaps_the_two_moving_orbits": True,
            "warning": "this realizes the quotient bit on P1; identifying it with C445's specific Rz transporter remains C450's comparison",
        },
        "prime_q": prime,
        "sheet": sheet,
        "split_torus_order": len(diagonal_psl_torus),
    }


def build_certificate():
    m0 = json.loads((HERE / "2026-07-21-c440-conventions-freeze.json").read_text())
    m1 = json.loads((HERE / "2026-07-21-c441-vertex-reduction-bijection.json").read_text())
    c399 = json.loads((HERE / "2026-07-20-c399-coxeter-number-conic-phase.json").read_text())
    phase = c399["symbolic"]["coxeter_number_phase_table"]

    octa = C441.build_octa(C440, m0)
    cube = C441.build_cube(C440, m0)
    h3 = C441.build_h3(C440, m0)

    octa_one, octa_zero = octa["o"]["ONE"], octa["o"]["ZERO"]
    cube_one, cube_zero = cube["o"]["ONE"], cube["o"]["ZERO"]
    a3_rotation = (-octa_one, octa_zero, octa_zero, octa_one)
    omega = C440.Qc((0, 0, 1, 0))
    b3_rotation = (omega, cube_zero, cube_zero, cube_one)
    h3_rotation = h3["S"]

    char0 = {
        "A3": char0_record(
            "A3", octa, a3_rotation,
            "square of the frozen order-4 multiplication-by-i Coxeter rotation: x -> i^2 x = -x",
        ),
        "B3": char0_record(
            "B3", cube, b3_rotation,
            "frozen body-diagonal Coxeter-square rotation x -> omega*x, omega^3=1",
        ),
        "H3": char0_record(
            "H3", h3, h3_rotation,
            "frozen C440 generator S=diag(zeta5,zeta5^(-1)); on x/y it is x -> zeta5^2*x",
        ),
    }
    assert {case: record["order_on_vertices"] for case, record in char0.items()} == {
        "A3": 2, "B3": 3, "H3": 5
    }

    c441_cases = m1["cases"]
    a3_table = c441_cases["A3_octahedron"]["bijection_table"]
    b3_table = c441_cases["B3_cube"]["bijection_table"]
    h3_table = c441_cases["H3_icosahedron"]["bijection_table"]
    expected = {
        "A3": [
            [row["point"] for row in a3_table if row["block"] == "real"],
            [row["point"] for row in a3_table if row["block"] == "imag"],
        ],
        "B3_pi": [
            [row["point_pi"] for row in b3_table if row["block"] == "upper"],
            [row["point_pi"] for row in b3_table if row["block"] == "lower"],
        ],
        "B3_pibar": [
            [row["point_pi_bar"] for row in b3_table if row["block"] == "upper"],
            [row["point_pi_bar"] for row in b3_table if row["block"] == "lower"],
        ],
        "H3_pi": [
            [row["point_pi"] for row in h3_table if row["block"] == "alpha"],
            [row["point_pi"] for row in h3_table if row["block"] == "beta"],
        ],
        "H3_pibar": [
            [row["point_pi_bar"] for row in h3_table if row["block"] == "alpha"],
            [row["point_pi_bar"] for row in h3_table if row["block"] == "beta"],
        ],
    }

    finite = [
        finite_record("A3", 5, "fused", (4, 0, 0, 1), 4, expected["A3"]),
        finite_record("B3", 7, "pi:sqrt2=3", (2, 0, 0, 1), 6, expected["B3_pi"]),
        finite_record("B3", 7, "pibar:sqrt2=4", (2, 0, 0, 1), 6, expected["B3_pibar"]),
        finite_record("H3", 11, "pi:zeta5=3", (9, 0, 0, 1), 10, expected["H3_pi"]),
        finite_record("H3", 11, "pibar:zeta5=9", (4, 0, 0, 1), 10, expected["H3_pibar"]),
    ]

    h3_pi = next(record for record in finite if record["sheet"] == "pi:zeta5=3")
    h3_pibar = next(record for record in finite if record["sheet"] == "pibar:zeta5=9")
    pi_generator = p1_action(tuple(h3_pi["generator_matrix_in_frozen_P1_frame"]), 1, 11)
    pibar_generator = p1_action(tuple(h3_pibar["generator_matrix_in_frozen_P1_frame"]), 1, 11)
    squaring_orbit = [pi_generator]
    for _ in range(3):
        squaring_orbit.append(pow(squaring_orbit[-1], 2, 11))
    assert pi_generator == 9 and pibar_generator == 4 == pow(pi_generator, 2, 11)
    assert squaring_orbit == [9, 4, 5, 3]
    assert pow(pi_generator, 4, 11) == pow(pi_generator, -1, 11)
    c462 = json.loads((HERE / "2026-07-21-c462-torsor-descent.json").read_text())
    c462_action = c462["acceptance"]["canonical_companion_action"]
    assert c462_action["sigma_is_four_cycle"]
    assert c462_action["sigma_square"] == c462_action["kappa_companion_permutation"]

    for case, h, q in (("A3", 4, 5), ("B3", 6, 7), ("H3", 10, 11)):
        assert phase[case]["coxeter_number_h"] == h
        assert phase[case]["coxeter_conic_field"] == q == h + 1
        assert phase[case]["middle_exponent_e"] == h // 2

    return {
        "char0_coxeter_square": char0,
        "consumes": input_records(),
        "finite_generator_images": finite,
        "h3_galois_torus_bridge": {
            "automorphism_group": "Aut(C5) = C4",
            "complex_conjugation_action": "g -> g^4 = g^(-1)",
            "frozen_generator_at_pi": pi_generator,
            "frozen_generator_at_pibar": pibar_generator,
            "semilinear_boundary": "the C4 action moves prime embeddings; it is not asserted to be one fixed PGL2(11) element",
            "sigma_action": "g -> g^2",
            "sigma_has_order_four_on_nonidentity_generators": True,
            "sigma_orbit_on_C5_generators": squaring_orbit,
            "sigma_square_is_kappa_in_C462": True,
        },
        "mechanism": {
            "all_images_are_split_torus_generators_in_PSL2": True,
            "conic_action": "2 fixed points plus q-1 moving points; the latter are the two square-coset orbits of size (q-1)/2",
            "derived_identity": "order(c^2)=h/2=(q-1)/2 when q=h+1",
            "interpretation": "the Coxeter square, not the orientation-reversing Coxeter element, is the rotation element tested",
            "normalization": "choose the frozen-group conjugate whose two eigenlines are 0 and infinity; inversion reverses the generator but preserves the torus and orbit partition",
            "quadratic_residue_bridge": "the middle exponent e=(q-1)/2 is the size of each Legendre coset, and the two moving blocks are exactly the square/nonsquare cosets",
            "weil_module_input": "on the P1 permutation module, restriction to the Coxeter torus is 2*trivial + 2*regular(C_e)",
            "verdict": "PASS",
        },
        "schema": SCHEMA,
        "task": "C449",
        "verdict": "GREEN_SPLIT_COXETER_SQUARE_TORUS_MECHANISM",
    }


def manifest_text():
    records = []
    for path in (REPORT_PATH, SCRIPT_PATH, REPLAY_PATH, JSON_PATH):
        data = path.read_bytes()
        records.append(f"{hashlib.sha256(data).hexdigest()}  {len(data)}  {path.name}")
    return "\n".join(records) + "\n"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = canonical_json(build_certificate())
    if args.check:
        assert JSON_PATH.read_text() == rendered, "canonical JSON is stale"
        assert SHA_PATH.read_text() == manifest_text(), "checksum manifest is stale"
        return
    JSON_PATH.write_text(rendered)
    SHA_PATH.write_text(manifest_text())


if __name__ == "__main__":
    main()
