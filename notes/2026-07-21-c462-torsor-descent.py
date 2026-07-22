#!/usr/bin/env python3
"""C462: certify the Z/4 action on the four golden companion orbits."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import math
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
STEM = "2026-07-21-c462-torsor-descent"
REPORT_PATH = HERE / f"{STEM}.md"
SCRIPT_PATH = HERE / f"{STEM}.py"
REPLAY_PATH = HERE / f"{STEM}-replay.py"
JSON_PATH = HERE / f"{STEM}.json"
SHA_PATH = HERE / f"{STEM}.sha256"
SCHEMA = "c462-torsor-descent-v1"

INPUT_FILES = (
    "2026-07-21-c440-conventions-freeze.json",
    "2026-07-21-c440-conventions-freeze.md",
    "2026-07-21-c443-commuting-with-reduction.json",
    "2026-07-21-c443-commuting-with-reduction.md",
    "2026-07-21-c443-commuting-with-reduction.py",
    "2026-07-21-c443-commuting-with-reduction.sha256",
    "2026-07-21-c443-torsor-hunch-check.md",
    "2026-07-21-c448-orbit-valued-selector.md",
    "2026-07-21-c458-golden-sheet-frame-freeze.json",
    "2026-07-21-c458-golden-sheet-frame-freeze.md",
    "2026-07-21-c461-four-companion-weight-line.json",
    "2026-07-21-c461-four-companion-weight-line.md",
    "2026-07-21-weil-roof-juice-m-chain.md",
    "2026-07-21-weil-roof-juice-x-chain.md",
)


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C461 = load("c462_c461", HERE / "2026-07-21-c461-four-companion-weight-line.py")
C443 = C461.C443
C406 = C443.C406
C399 = C443.C399


def canonical_json(value) -> str:
    return json.dumps(value, indent=2, sort_keys=True) + "\n"


def file_record(path: Path):
    data = path.read_bytes()
    return {"bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()}


def input_records():
    return {name: file_record(HERE / name) for name in INPUT_FILES}


def determinant_fraction(matrix):
    work = [list(row) for row in matrix]
    answer = Fraction(1)
    for column in range(len(work)):
        pivot = next(row for row in range(column, len(work)) if work[row][column])
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            answer = -answer
        diagonal = work[column][column]
        answer *= diagonal
        for row in range(column + 1, len(work)):
            scale = work[row][column] / diagonal
            for index in range(column + 1, len(work)):
                work[row][index] -= scale * work[column][index]
    return answer


def field_norm(value):
    basis = tuple(
        C443.Z5(tuple(Fraction(int(index == power)) for index in range(4)))
        for power in range(4)
    )
    columns = tuple((value * basis_vector).c for basis_vector in basis)
    matrix = tuple(tuple(columns[column][row] for column in range(4)) for row in range(4))
    return determinant_fraction(matrix)


def primitive_matrix(matrix):
    denominators = [coefficient.denominator for entry in matrix for coefficient in entry.c]
    common = math.lcm(*denominators)
    coefficients = [
        int(coefficient * common) for entry in matrix for coefficient in entry.c
    ]
    divisor = math.gcd(*(abs(value) for value in coefficients if value))
    coefficients = [value // divisor for value in coefficients]
    first = next(value for value in coefficients if value)
    if first < 0:
        coefficients = [-value for value in coefficients]
    return tuple(
        C443.Z5(tuple(Fraction(coefficients[4 * entry + index]) for index in range(4)))
        for entry in range(4)
    )


def encoded_matrix(matrix):
    return [
        [str(coefficient) for coefficient in entry.c]
        for entry in matrix
    ]


def matrix_key(matrix):
    return tuple(coefficient for entry in matrix for coefficient in entry.c)


def induced_permutation(vertex_permutation, candidates):
    index = {frozenset(orbit): position for position, orbit in enumerate(candidates)}
    return tuple(
        index[
            frozenset(
                C443.matching_image(vertex_permutation, matching) for matching in orbit
            )
        ]
        for orbit in candidates
    )


def conic_parameters(points):
    u = (-C443.PHI, C443.RHO, C443.ONE)
    e = (C443.PHI, -C443.RHO, C443.ONE)
    w = C443.vec_cross(u, e)
    bridge = tuple(tuple(column[row] for column in (u, w, e)) for row in range(3))
    inverse = C443.mat_inverse(bridge)

    def parameter(point):
        x, y, z = C443.mat_vec(inverse, point)
        return C443.normalize_pair((x, y) if not x.iszero() else (y, z))

    return tuple(parameter(point) for point in points), bridge


def maps_between(source, target):
    target_set = set(target)
    source_standard = C443.frame_to_standard(source[:3])
    answer = {}
    for target_frame in itertools.permutations(target, 3):
        target_standard = C443.frame_to_standard(target_frame)
        matrix = C443.mat2_mul(C443.mat2_inverse(target_standard), source_standard)
        if {C443.mat2_apply(matrix, point) for point in source} != target_set:
            continue
        primitive = primitive_matrix(matrix)
        answer[matrix_key(primitive)] = primitive
    return tuple(answer[key] for key in sorted(answer))


def finite_sheet_data(reductions, candidates):
    conic, parameters = C399.conic_parameterization(11)
    scout = json.loads((HERE / "2026-07-20-c406-matching-orbit-scout.json").read_text())
    h3 = next(record for record in scout["types"] if record["type"] == "H3")
    base = tuple(tuple(pair) for pair in h3["coxeter_invariant_matching"])
    full_group, psl_group = C406.full_pgl(11, parameters)
    full_orbit = frozenset(C406.matching_image(element, base) for element in full_group)
    base_sheet = frozenset(C406.matching_image(element, base) for element in psl_group)
    outer_sheet = full_orbit - base_sheet
    root_data = {
        3: ("pi", 8),
        4: ("pi", 8),
        5: ("pibar", 4),
        9: ("pibar", 4),
    }
    records = []
    companion_to_root = {}
    for root in (3, 4, 5, 9):
        prime, phi = root_data[root]
        for index in range(len(candidates)):
            factorization = reductions[(root, index)]
            sheet = "base" if factorization == base_sheet else (
                "outer" if factorization == outer_sheet else None
            )
            if sheet is not None:
                assert index not in companion_to_root
                companion_to_root[index] = root
                records.append(
                    {
                        "companion": index,
                        "golden_prime": prime,
                        "phi_mod_11": phi,
                        "sheet": sheet,
                        "zeta_mod_11": root,
                    }
                )
    assert len(companion_to_root) == 4
    return sorted(records, key=lambda record: record["companion"]), companion_to_root


def discrepancy_records(moments, frozen):
    inverse_two = pow(2, -1, 11)

    def combine(left, right, left_scale=1, right_scale=-1):
        return [
            (left_scale * a + right_scale * b) % 11 for a, b in zip(left, right)
        ]

    frozen_by_pair = {
        tuple(record["candidates"]): record["degrees"]["1"]
        for record in frozen["finite_reductions"]["kappa_pair_moment_review"]
    }
    answer = []
    for pair in ((0, 3), (1, 2)):
        at_three = combine(
            moments[(3, pair[0], 1)], moments[(3, pair[1], 1)], inverse_two, inverse_two
        )
        at_nine = combine(
            moments[(9, pair[0], 1)], moments[(9, pair[1], 1)], inverse_two, inverse_two
        )
        vector = combine(at_three, at_nine)
        digest = hashlib.sha256(bytes(vector)).hexdigest()
        frozen_record = frozen_by_pair[pair]
        assert digest == frozen_record["mu_at_pi_sha256"]
        answer.append(
            {
                "c443_mu_at_pi_sha256": frozen_record["mu_at_pi_sha256"],
                "candidates": list(pair),
                "degree": 1,
                "sha256": digest,
                "support": [index for index, value in enumerate(vector) if value],
                "vector_mod_11": vector,
            }
        )
    assert answer[0]["vector_mod_11"] == answer[1]["vector_mod_11"]
    return answer


def build_certificate():
    points, candidates, kappa_candidates, reductions, moments, _targets = C461.finite_geometry()
    assert tuple(kappa_candidates) == (3, 2, 1, 0)
    parameters, conic_bridge = conic_parameters(points)
    sigma_points = tuple(
        C443.normalize_point(tuple(C443.zauto(coordinate, 2) for coordinate in point))
        for point in points
    )
    sigma_parameters, _ = conic_parameters(sigma_points)

    correcting_maps = maps_between(parameters, sigma_parameters)
    automorphisms = maps_between(parameters, parameters)
    assert len(correcting_maps) == len(automorphisms) == 60

    point_index = {point: index for index, point in enumerate(parameters)}
    golden_group_permutations = set()
    qgroup = C443.C442.q_closure(
        [
            C443.C442.qnormmat(C443.C442.q_refl(root))
            for root in C443.C442.q_roots(C443.C442.QPHI)
        ]
    )
    group = tuple(
        tuple(tuple(C443.q_to_z5(entry) for entry in row) for row in matrix)
        for matrix in qgroup
    )
    original_point_index = {point: index for index, point in enumerate(points)}
    for matrix in group:
        golden_group_permutations.add(
            tuple(
                original_point_index[C443.normalize_point(C443.mat_vec(matrix, point))]
                for point in points
            )
        )
    automorphism_permutations = {
        tuple(point_index[C443.mat2_apply(matrix, point)] for point in parameters)
        for matrix in automorphisms
    }
    assert automorphism_permutations == golden_group_permutations

    correction_records = []
    companion_actions = set()
    for matrix in correcting_maps:
        inverse = C443.mat2_inverse(matrix)
        correspondence = tuple(
            point_index[C443.mat2_apply(inverse, sigma_parameters[index])]
            for index in range(12)
        )
        action = induced_permutation(correspondence, candidates)
        companion_actions.add(action)
        determinant = matrix[0] * matrix[3] - matrix[1] * matrix[2]
        correction_records.append(
            {
                "companion_permutation": list(action),
                "determinant": [str(value) for value in determinant.c],
                "determinant_norm": str(field_norm(determinant)),
                "matrix": encoded_matrix(matrix),
                "sigma_image_vertex_correspondence": list(correspondence),
            }
        )
    assert companion_actions == {(2, 0, 3, 1)}
    sigma_companions = next(iter(companion_actions))
    sigma_square = tuple(sigma_companions[sigma_companions[index]] for index in range(4))
    assert sigma_square == tuple(kappa_candidates)

    eligible = [
        record for record in correction_records if Fraction(record["determinant_norm"]).denominator == 1
        and abs(int(Fraction(record["determinant_norm"]))) in (1, 2, 4, 8, 16)
    ]
    assert eligible
    witness = min(eligible, key=lambda record: tuple(sum(record["matrix"], [])))

    reduction_table, companion_to_root = finite_sheet_data(reductions, candidates)
    residue_action = tuple(
        next(
            companion
            for companion, root in companion_to_root.items()
            if root == pow(companion_to_root[index], 2, 11)
        )
        for index in range(4)
    )
    inverse_sigma = tuple(sigma_companions.index(index) for index in range(4))
    assert residue_action == inverse_sigma
    assert {
        frozenset((companion_to_root[0], companion_to_root[3])),
        frozenset((companion_to_root[1], companion_to_root[2])),
    } == {frozenset((3, 4)), frozenset((5, 9))}

    frozen_c443 = json.loads((HERE / "2026-07-21-c443-commuting-with-reduction.json").read_text())
    discrepancies = discrepancy_records(moments, frozen_c443)

    return {
        "acceptance": {
            "canonical_companion_action": {
                "all_60_corrections_give_same_permutation": True,
                "kappa_companion_permutation": list(kappa_candidates),
                "sigma_companion_permutation": list(sigma_companions),
                "sigma_cycle": [0, 2, 3, 1],
                "sigma_is_four_cycle": True,
                "sigma_square": list(sigma_square),
            },
            "companion_to_residue": {
                "kappa_pairs": [[0, 3], [1, 2]],
                "records": reduction_table,
                "residue_action_induced_by_z_to_z_squared": list(residue_action),
                "residue_kappa_pairs": [[3, 4], [5, 9]],
                "sigma_orientation_relation": "residue action is inverse to the chosen corrected-sigma action; both square to kappa",
            },
            "degree_one_discrepancy": {
                "galois_invariant": True,
                "pair_records": discrepancies,
                "pairs_have_identical_vectors": True,
            },
            "sigma_image": {
                "automorphism_group_equals_frozen_golden_A5": True,
                "automorphism_group_order": len(automorphisms),
                "conic_bridge": [encoded_matrix(row) for row in conic_bridge],
                "correcting_map_count": len(correcting_maps),
                "correcting_maps_form_torsor_under_A5_normalizer": True,
                "literal_common_vertices": len(set(points) & set(sigma_points)),
                "witness": witness,
            },
        },
        "consumes": input_records(),
        "descent_statement": {
            "base_ring": "Z[phi,1/10]",
            "base_changed_object": "the four companion one-factorizations with their equivariant map to the two golden primes above 11 and frozen base/outer sheet labels",
            "cyclotomic_ring": "Z[zeta5,1/10]",
            "denominator_set_N_prime": 10,
            "eleven_is_not_inverted": True,
            "inverted_rational_primes": [2, 5],
            "localization_reasons": {
                "2": "the displayed correcting projectivity has determinant norm 16 and pair averages use 1/2",
                "5": "Z[zeta5]/Z[phi] is ramified only above 5; inverting 5 makes the kappa extension finite etale",
            },
            "obstruction": {
                "character": "chi_pi:<kappa>->C2 is surjective",
                "fibres": {"pi": [0, 3], "pibar": [1, 2]},
                "free_kappa_action": [[0, 3], [1, 2]],
                "orbit_valued_family_descends": True,
                "point_valued_companion_section_descends": False,
                "precise_scope": "the obstruction is to a chosen companion in each prime fibre, exactly the M3a selector; it is not an obstruction to descending the unordered family",
            },
            "recommendation": "replace the cut paper-1 tensor clause only by the base-changed equivariant companion-sheet family together with the proved kappa selector obstruction; do not claim an M3a tensor or rank-4 module acceptance item",
        },
        "schema": SCHEMA,
        "task": "C462",
        "verdict": "GREEN_Z4_COMPANION_TORSOR_WITH_KAPPA_SELECTOR_OBSTRUCTION",
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
