#!/usr/bin/env python3
"""C461: exact mod-11 necessary test for a four-companion integral weight line."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
STEM = "2026-07-21-c461-four-companion-weight-line"
C443_PATH = HERE / "2026-07-21-c443-commuting-with-reduction.py"
REPORT_PATH = HERE / f"{STEM}.md"
REPLAY_PATH = HERE / f"{STEM}-replay.py"
JSON_PATH = HERE / f"{STEM}.json"
SHA_PATH = HERE / f"{STEM}.sha256"
SCHEMA = "c461-four-companion-weight-line-v1"

INPUT_FILES = (
    "2026-07-21-c443-commuting-with-reduction.py",
    "2026-07-21-c443-commuting-with-reduction.json",
    "2026-07-21-c443-commuting-with-reduction.sha256",
    "2026-07-20-c406-matching-module.py",
    "2026-07-20-c406-matching-orbit-scout.json",
    "2026-07-21-c442-antipodal-singleton-reduction.py",
    "2026-07-21-c458-golden-sheet-frame-freeze.json",
)


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C443 = load("c461_c443", C443_PATH)
C406 = C443.C406
C399 = C443.C399


def transpose(columns):
    return [list(row) for row in zip(*columns)]


def combine(vectors, coefficients):
    return [
        sum(coefficient * vector[index] for coefficient, vector in zip(coefficients, vectors)) % 11
        for index in range(len(vectors[0]))
    ]


def difference(left, right):
    return [(a - b) % 11 for a, b in zip(left, right)]


def file_hashes():
    answer = {}
    for name in INPUT_FILES:
        data = (HERE / name).read_bytes()
        answer[name] = {"bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()}
    return answer


def finite_geometry():
    u = (-C443.PHI, C443.RHO, C443.ONE)
    qgroup = C443.C442.q_closure(
        [C443.C442.qnormmat(C443.C442.q_refl(root)) for root in C443.C442.q_roots(C443.C442.QPHI)]
    )
    group = tuple(
        tuple(tuple(C443.q_to_z5(entry) for entry in row) for row in matrix) for matrix in qgroup
    )
    points = tuple(sorted({C443.normalize_point(C443.mat_vec(matrix, u)) for matrix in group}, key=C443.point_key))
    point_index = {point: index for index, point in enumerate(points)}
    permutations = tuple(
        tuple(point_index[C443.normalize_point(C443.mat_vec(matrix, point))] for point in points)
        for matrix in group
    )
    six_arc = tuple(
        tuple(C443.q_to_z5(entry) for entry in point) for point in C443.C442.q_six(C443.C442.QPHI)
    )
    polar = tuple(
        sorted(
            tuple(sorted(index for index, point in enumerate(points) if C443.vec_dot(pole, point).iszero()))
            for pole in six_arc
        )
    )
    matchings = tuple(C443.perfect_matchings(range(12)))
    orbits = C443.matching_orbits(matchings, permutations)
    candidates = tuple(
        orbit for orbit in orbits if len(orbit) == 10 and C443.is_one_factorization((polar,) + orbit)
    )
    assert len(candidates) == 4
    kappa_vertices = tuple(
        point_index[C443.normalize_point(tuple(C443.kappa(coordinate) for coordinate in point))]
        for point in points
    )
    candidate_index = {frozenset(orbit): index for index, orbit in enumerate(candidates)}
    kappa_candidates = tuple(
        candidate_index[
            frozenset(C443.matching_image(kappa_vertices, matching) for matching in orbit)
        ]
        for orbit in candidates
    )
    assert kappa_candidates == (3, 2, 1, 0)

    conic, parameters = C399.conic_parameterization(11)
    conic_index = {point: index for index, point in enumerate(conic)}
    scout = json.loads((HERE / "2026-07-20-c406-matching-orbit-scout.json").read_text())
    h3_record = next(record for record in scout["types"] if record["type"] == "H3")
    finite_base = tuple(tuple(pair) for pair in h3_record["coxeter_invariant_matching"])
    full_group, psl_group = C406.full_pgl(11, parameters)
    full_orbit = frozenset(C406.matching_image(element, finite_base) for element in full_group)
    base_sheet = frozenset(C406.matching_image(element, finite_base) for element in psl_group)
    other_sheet = full_orbit - base_sheet
    base_product = C406.matching_product(finite_base, parameters, 11)

    reductions = {}
    moments = {}
    for root in (3, 4, 5, 9):
        vertex_map = tuple(
            conic_index[C443.reduce_projective_point(point, root)] for point in points
        )
        for index, candidate in enumerate(candidates):
            factorization = frozenset(
                C443.matching_image(vertex_map, matching) for matching in (polar,) + candidate
            )
            reductions[(root, index)] = factorization
            vectors = C443.finite_quotient_vectors(factorization, parameters, base_product)
            for degree in (1, 2, 3):
                moments[(root, index, degree)] = C443.finite_moment(vectors, degree)
    targets = {}
    for degree in (1, 2, 3):
        base_moment = C443.finite_moment(
            C443.finite_quotient_vectors(base_sheet, parameters, base_product), degree
        )
        other_moment = C443.finite_moment(
            C443.finite_quotient_vectors(other_sheet, parameters, base_product), degree
        )
        targets[degree] = difference(base_moment, other_moment)
    return points, candidates, kappa_candidates, reductions, moments, targets


def build_certificate():
    assert C443.RHO * C443.RHO == -C443.PHI - C443.zconst(2)
    points, candidates, kappa_candidates, reductions, moments, targets = finite_geometry()
    roots = (3, 4, 5, 9)
    rho_values = {root: C443.reduce_z5(C443.RHO, root) for root in roots}

    # O-basis of the kappa-fixed descent of E^4 for kappa=(0 3)(1 2):
    # e0+e3, rho(e0-e3), e1+e2, rho(e1-e2), with kappa(rho)=-rho.
    def weights(root):
        rho = rho_values[root]
        return (
            (1, 0, 0, 1),
            (rho, 0, 0, -rho % 11),
            (0, 1, 1, 0),
            (0, rho, -rho % 11, 0),
        )

    descended = {}
    for root in roots:
        for degree in (1, 2, 3):
            candidate_vectors = [moments[(root, index, degree)] for index in range(4)]
            for basis_index, coefficients in enumerate(weights(root)):
                descended[(root, degree, basis_index)] = combine(candidate_vectors, coefficients)

    assert all(
        descended[(3, degree, basis)] == descended[(4, degree, basis)]
        and descended[(5, degree, basis)] == descended[(9, degree, basis)]
        for degree in (1, 2, 3)
        for basis in range(4)
    )

    mu_columns = {}
    for degree in (1, 2, 3):
        mu_columns[degree] = [
            difference(descended[(3, degree, basis)], descended[(9, degree, basis)])
            for basis in range(4)
        ]
    lower_matrix = transpose(mu_columns[1]) + transpose(mu_columns[2])
    lower_rank = C406.rank(lower_matrix, 11)
    lower_kernel = C406.nullspace(lower_matrix, 11)
    degree_ranks = {
        str(degree): C406.rank(transpose(mu_columns[degree]), 11) for degree in (1, 2, 3)
    }

    assert lower_rank == 4 and not lower_kernel
    assert degree_ranks == {"1": 1, "2": 4, "3": 4}
    symmetric_bases = {
        str(degree): [list(indices) for indices in itertools.combinations_with_replacement(range(15), degree)]
        for degree in (1, 2, 3)
    }
    return {
        "schema": SCHEMA,
        "task": "C461",
        "verdict": "SHARP_NEGATIVE_ZERO_MOD11_LOWER_MOMENT_KERNEL",
        "consumes": file_hashes(),
        "candidate_count": len(candidates),
        "rings": {
            "E0": "Z[zeta5]",
            "O0": "Z[phi]",
            "localized_descent_lattice": "O0[1/2]^4",
            "rho": "zeta5-zeta5^(-1)",
            "rho_squared": "-phi-2",
            "eleven_inverted": False,
            "why_half_is_harmless": "2 is a unit modulo 11 and was pre-authorized by C443 M3a",
        },
        "galois": {
            "kappa_candidate_permutation": list(kappa_candidates),
            "kappa_candidate_cycle_lengths": [2, 2],
            "kappa_rho": "-rho",
            "sigma_zeta": "zeta^2",
            "sigma_root_map": {"3": 9, "4": 5, "5": 3, "9": 4},
            "sigma_maps_golden_weighted_object_to_conjugate_copy": True,
            "golden_odd_map_tested": "D-sigma(D)",
        },
        "weight_lattice": {
            "rank_over_O0_after_inverting_2": 4,
            "basis": [
                "e0+e3",
                "rho*(e0-e3)",
                "e1+e2",
                "rho*(e1-e2)",
            ],
            "rho_reductions": {str(root): rho_values[root] for root in roots},
            "descent_agrees_at_zeta_3_4_and_5_9": True,
        },
        "codomains": {
            "S4_rank": 15,
            "symmetric_bases": symmetric_bases,
            "symmetric_ranks": {key: len(value) for key, value in symmetric_bases.items()},
        },
        "moment_maps_mod_11": {
            str(degree): {
                "rank": degree_ranks[str(degree)],
                "columns_in_weight_basis": mu_columns[degree],
                "column_sha256": [
                    hashlib.sha256(bytes(column)).hexdigest() for column in mu_columns[degree]
                ],
                "target_C406_base_minus_outer": targets[degree],
                "target_support": sum(value != 0 for value in targets[degree]),
                "target_sha256": hashlib.sha256(bytes(targets[degree])).hexdigest(),
            }
            for degree in (1, 2, 3)
        },
        "necessary_lower_moment_test": {
            "stacked_degree_1_2_matrix": lower_matrix,
            "rank": lower_rank,
            "kernel_basis": lower_kernel,
            "kernel_dimension": len(lower_kernel),
            "desired_weight_line_survives": False,
            "logical_conclusion": "a primitive integral weight with nonzero cubic shadow has nonzero mod-11 reduction, but vanishing lower shadows would put that reduction in this zero kernel",
        },
        "scope": {
            "closed": "all kappa-descended linear weightings of C443's four companion secant-sheet moment sums",
            "not_closed": "an abstract integral tensor constructed directly in the invariant tensor lattice rather than from the four companion moments",
            "cubic_and_plus_minus_6_comparison_reached": False,
            "reason_cubic_comparison_unreached": "no nonzero weight passes the necessary lower-moment gate",
        },
    }


def canonical_json(certificate):
    return json.dumps(certificate, indent=2, sort_keys=True) + "\n"


def manifest_text(json_data):
    entries = []
    for path in (REPORT_PATH, Path(__file__), REPLAY_PATH, JSON_PATH):
        data = json_data if path == JSON_PATH else path.read_bytes()
        entries.append((hashlib.sha256(data).hexdigest(), len(data), path.name))
    return "".join(f"{digest}  {size}  {name}\n" for digest, size, name in entries)


def main(argv):
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args(argv)
    data = canonical_json(build_certificate()).encode()
    manifest = manifest_text(data)
    if args.check:
        ok = JSON_PATH.exists() and JSON_PATH.read_bytes() == data
        ok = ok and SHA_PATH.exists() and SHA_PATH.read_text() == manifest
        print("C461 CHECK OK" if ok else "C461 CHECK FAILED")
        return 0 if ok else 1
    JSON_PATH.write_bytes(data)
    SHA_PATH.write_text(manifest)
    print(f"wrote {JSON_PATH.name} ({len(data)} bytes) and {SHA_PATH.name}")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
