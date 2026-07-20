#!/usr/bin/env python3
"""Exact bounded probes for post-C438 theta/Steiner bridge candidates."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from math import comb
from itertools import combinations
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parent.parent
STEM = "2026-07-20-c438-postmortem-bridge-vectors"
C435_SCRIPT = ROOT / "notes/2026-07-20-c435-hermitian-determinantal-tower.py"
C435_JSON = ROOT / "notes/2026-07-20-c435-hermitian-determinantal-tower.json"
OUTPUT = ROOT / f"notes/{STEM}.json"


def load_c435():
    spec = importlib.util.spec_from_file_location("c435_bridge_input", C435_SCRIPT)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def bilinear(module, left, matrix, right) -> int:
    answer = 0
    for i in range(4):
        for j in range(4):
            term = module.FIELD.mul(left[i], module.FIELD.mul(matrix[i][j], right[j]))
            answer = module.FIELD.add(answer, term)
    return answer


def steiner_objects() -> tuple[tuple[str, tuple[int, ...]], ...]:
    type_v = [("V", pair) for pair in combinations(range(8), 2)]
    type_parallel = set()
    for subset in combinations(range(8), 4):
        complement = tuple(index for index in range(8) if index not in subset)
        type_parallel.add(("II", min(subset, complement)))
    return tuple(type_v + sorted(type_parallel))


def act_on_steiner(permutation, obj):
    kind, subset = obj
    image = tuple(sorted(permutation[index] for index in subset))
    if kind == "II":
        complement = tuple(index for index in range(8) if index not in image)
        image = min(image, complement)
    return kind, image


def orbit_profile(group, objects) -> list[dict[str, Any]]:
    remaining = set(objects)
    answer = []
    while remaining:
        seed = min(remaining)
        orbit = {act_on_steiner(permutation, seed) for permutation in group}
        answer.append({"type": seed[0], "size": len(orbit)})
        remaining -= orbit
    return sorted(answer, key=lambda item: (item["type"], item["size"]))


def standard_affine_group(multipliers: tuple[int, ...]):
    group = set()
    for scale in multipliers:
        for shift in range(7):
            group.add(tuple((scale * value + shift) % 7 for value in range(7)) + (7,))
    return group


def rank_mod_prime(matrix: list[list[int]], prime: int) -> int:
    work = [row[:] for row in matrix]
    rank = 0
    for column in range(len(work[0])):
        pivot = next((row for row in range(rank, len(work)) if work[row][column]), None)
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        scale = pow(work[rank][column], -1, prime)
        work[rank] = [(scale * value) % prime for value in work[rank]]
        for row in range(len(work)):
            if row != rank and work[row][column]:
                scale = work[row][column]
                work[row] = [
                    (value - scale * pivot_value) % prime
                    for value, pivot_value in zip(work[row], work[rank])
                ]
        rank += 1
    return rank


def generate() -> dict[str, Any]:
    module = load_c435()
    octad, parent, quadrics, _, _ = module.load_c405()
    quadric_matrices = tuple(module.quadric_matrix(quadric) for quadric in quadrics)

    bitangent_forms = {}
    for left, right in combinations(range(8), 2):
        form = module.normalize(
            tuple(bilinear(module, octad[left], matrix, octad[right]) for matrix in quadric_matrices)
        )
        bitangent_forms[f"{left}-{right}"] = list(form)

    octad_group, parent_group = module.enumerate_octad_stabilizer(octad, parent)
    _, semilinear_parent_coset = module.enumerate_semilinear_octad_coset(octad, parent)
    point_index = {point: index for index, point in enumerate(octad)}
    projective_permutations = {module.point_permutation(matrix, octad) for matrix in parent_group}
    semilinear_permutations = set(projective_permutations)
    for matrix in semilinear_parent_coset:
        semilinear_permutations.add(
            tuple(
                point_index[module.apply_projectivity(matrix, module.frobenius_vector(point))]
                for point in octad
            )
        )

    objects = steiner_objects()
    projective_profile = orbit_profile(projective_permutations, objects)
    semilinear_profile = orbit_profile(semilinear_permutations, objects)
    standard_projective_profile = orbit_profile(standard_affine_group((1, 2, 4)), objects)
    standard_semilinear_profile = orbit_profile(standard_affine_group((1, 2, 3, 4, 5, 6)), objects)
    assert projective_profile == standard_projective_profile
    assert semilinear_profile == standard_semilinear_profile

    row_sizes = [sum(index in pair for pair in combinations(range(8), 2)) for index in range(8)]
    assert len(bitangent_forms) == 28
    assert len({tuple(form) for form in bitangent_forms.values()}) == 28
    assert row_sizes == [7] * 8
    assert len(projective_permutations) == 21
    assert len(semilinear_permutations) == 42
    assert all(item["size"] != 1 for item in projective_profile + semilinear_profile)

    # For H_11 : y^2=x^11-x, f^((p-1)/2)=f^5 has exponents 10k+5.
    coefficients = {10 * k + 5: ((-1) ** (5 - k) * comb(5, k)) % 11 for k in range(6)}
    hasse_witt = [
        [coefficients.get(11 * (row + 1) - (column + 1), 0) for column in range(5)]
        for row in range(5)
    ]
    hasse_witt_rank = rank_mod_prime(hasse_witt, 11)
    assert hasse_witt_rank == 0

    return {
        "schema": "c438-postmortem-bridge-vectors-v1",
        "inputs": {
            "c435_checker_sha256": sha256(C435_SCRIPT),
            "c435_certificate_sha256": sha256(C435_JSON),
        },
        "cayley_bitangent_matrix": {
            "formula": "b_ij(lambda)=O_i^T(sum_k lambda_k Q_k)O_j",
            "pair_labels": 28,
            "distinct_projective_linear_forms": 28,
            "marked_point_row_sizes": row_sizes,
            "forms_by_pair": dict(sorted(bitangent_forms.items())),
            "trusted_classical_identification": "off-diagonal Cayley bitangent-matrix forms",
        },
        "steiner_complex_parent_stabilizer_orbits": {
            "objects": {"type_V": 28, "type_II": 35, "total": 63},
            "projective_parent_stabilizer_order": len(projective_permutations),
            "projective_profile": projective_profile,
            "semilinear_parent_stabilizer_order": len(semilinear_permutations),
            "semilinear_profile": semilinear_profile,
            "fixed_complexes_projective": 0,
            "fixed_complexes_semilinear": 0,
            "independent_replay": "standard affine groups 7:3 and 7:6 on F7 plus infinity",
        },
        "q11_hyperelliptic_host": {
            "curve": "y^2=x^11-x",
            "genus": 5,
            "branch_locus": "P1(F11), identified with the twelve C379 conic points",
            "two_torsion_model": "even subsets of 12 branch points modulo the all-one subset",
            "matching_kernel_dimension": 5,
            "hasse_witt_matrix": hasse_witt,
            "hasse_witt_rank": hasse_witt_rank,
            "boundary": "rank zero is certified; superspeciality and quotient-Jacobian claims are not",
        },
    }


def serialize(data: dict[str, Any]) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = serialize(generate())
    if args.write:
        OUTPUT.write_bytes(data)
    if args.check:
        assert OUTPUT.read_bytes() == data, f"stale output: {OUTPUT}"
        print("C438 postmortem bridge-vector certificate: OK")
    if not args.write and not args.check:
        print(data.decode(), end="")


if __name__ == "__main__":
    main()
