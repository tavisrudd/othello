#!/usr/bin/env python3
"""Independent replay of the C462 torsor invariants (does not import C462)."""

from __future__ import annotations

import importlib.util
import itertools
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C443 = load("c462_replay_c443", HERE / "2026-07-21-c443-commuting-with-reduction.py")
C406 = C443.C406
C399 = C443.C399


def reconstruct_geometry():
    u = (-C443.PHI, C443.RHO, C443.ONE)
    qgroup = C443.C442.q_closure(
        [C443.C442.qnormmat(C443.C442.q_refl(root)) for root in C443.C442.q_roots(C443.C442.QPHI)]
    )
    group = tuple(
        tuple(tuple(C443.q_to_z5(entry) for entry in row) for row in matrix)
        for matrix in qgroup
    )
    points = tuple(
        sorted(
            {C443.normalize_point(C443.mat_vec(matrix, u)) for matrix in group},
            key=C443.point_key,
        )
    )
    point_index = {point: index for index, point in enumerate(points)}
    permutations = tuple(
        tuple(
            point_index[C443.normalize_point(C443.mat_vec(matrix, point))]
            for point in points
        )
        for matrix in group
    )
    six_arc = tuple(
        tuple(C443.q_to_z5(entry) for entry in point)
        for point in C443.C442.q_six(C443.C442.QPHI)
    )
    polar = tuple(
        sorted(
            tuple(
                sorted(
                    index
                    for index, point in enumerate(points)
                    if C443.vec_dot(pole, point).iszero()
                )
            )
            for pole in six_arc
        )
    )
    orbits = C443.matching_orbits(tuple(C443.perfect_matchings(range(12))), permutations)
    companions = tuple(
        orbit
        for orbit in orbits
        if len(orbit) == 10 and C443.is_one_factorization((polar,) + orbit)
    )
    assert len(group) == 60 and len(points) == 12 and len(companions) == 4
    return points, companions


def parameters(points):
    u = (-C443.PHI, C443.RHO, C443.ONE)
    e = (C443.PHI, -C443.RHO, C443.ONE)
    w = C443.vec_cross(u, e)
    bridge = tuple(tuple(column[row] for column in (u, w, e)) for row in range(3))
    inverse = C443.mat_inverse(bridge)
    answer = []
    for point in points:
        x, y, z = C443.mat_vec(inverse, point)
        answer.append(C443.normalize_pair((x, y) if not x.iszero() else (y, z)))
    return tuple(answer)


def replay():
    certificate = json.loads((HERE / "2026-07-21-c462-torsor-descent.json").read_text())
    points, companions = reconstruct_geometry()
    source = parameters(points)
    sigma_points = tuple(
        C443.normalize_point(tuple(C443.zauto(coordinate, 2) for coordinate in point))
        for point in points
    )
    target = parameters(sigma_points)

    witness_data = certificate["acceptance"]["sigma_image"]["witness"]
    witness = tuple(
        C443.Z5(tuple(Fraction(value) for value in row))
        for row in witness_data["matrix"]
    )
    assert {C443.mat2_apply(witness, point) for point in source} == set(target)
    inverse = C443.mat2_inverse(witness)
    source_index = {point: index for index, point in enumerate(source)}
    correspondence = tuple(
        source_index[C443.mat2_apply(inverse, point)] for point in target
    )
    assert list(correspondence) == witness_data["sigma_image_vertex_correspondence"]

    companion_index = {frozenset(orbit): index for index, orbit in enumerate(companions)}
    action = tuple(
        companion_index[
            frozenset(C443.matching_image(correspondence, matching) for matching in orbit)
        ]
        for orbit in companions
    )
    assert action == (2, 0, 3, 1)
    assert tuple(action[action[index]] for index in range(4)) == (3, 2, 1, 0)

    # Independent count: one Mobius map is determined by the images of a fixed source triple.
    source_standard = C443.frame_to_standard(source[-3:])
    count = 0
    for target_frame in itertools.permutations(target, 3):
        target_standard = C443.frame_to_standard(target_frame)
        matrix = C443.mat2_mul(C443.mat2_inverse(target_standard), source_standard)
        if {C443.mat2_apply(matrix, point) for point in source} == set(target):
            count += 1
    assert count == certificate["acceptance"]["sigma_image"]["correcting_map_count"] == 60

    table = certificate["acceptance"]["companion_to_residue"]["records"]
    companion_to_root = {record["companion"]: record["zeta_mod_11"] for record in table}
    residue_action = tuple(
        next(
            companion
            for companion, root in companion_to_root.items()
            if root == pow(companion_to_root[index], 2, 11)
        )
        for index in range(4)
    )
    assert residue_action == tuple(action.index(index) for index in range(4))

    discrepancies = certificate["acceptance"]["degree_one_discrepancy"]["pair_records"]
    assert discrepancies[0]["vector_mod_11"] == discrepancies[1]["vector_mod_11"]
    assert discrepancies[0]["vector_mod_11"] == [0, 0, 0, 0, 2, 0, 0, 7, 0, 2, 0, 0, 0, 0, 0]
    print("C462 independent replay: OK (60 corrections, Z/4 action, residue equivariance, invariant discrepancy)")


if __name__ == "__main__":
    replay()
