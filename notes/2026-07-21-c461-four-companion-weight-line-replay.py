#!/usr/bin/env python3
"""Independent binary-frame replay of C461's zero lower-moment kernel."""

from __future__ import annotations

import importlib.util
import itertools
import json
from collections import Counter
from fractions import Fraction as F
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-21-c461-four-companion-weight-line.json"


def load(stem):
    path = HERE / f"{stem}.py"
    spec = importlib.util.spec_from_file_location(f"c461_replay_{stem.replace('-', '_')}", path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C440 = load("2026-07-21-c440-conventions-freeze")
C442 = load("2026-07-21-c442-antipodal-singleton-reduction")
C406 = load("2026-07-20-c406-matching-module")
C399 = C406.C399

Z5 = C440.Z5
OPS = C440.ops(Z5)
ZERO = OPS["ZERO"]
ONE = OPS["ONE"]
ZETA = Z5((0, 1, 0, 0))
ZETA_INV = Z5((-1, -1, -1, -1))
PHI = ONE + ZETA + ZETA_INV
RHO = ZETA - ZETA_INV


def zconst(value):
    return Z5((F(value), F(0), F(0), F(0)))


def zpow(value, exponent):
    answer = ONE
    while exponent:
        if exponent & 1:
            answer = answer * value
        value = value * value
        exponent //= 2
    return answer


def kappa(value):
    return sum(
        (zconst(coefficient) * zpow(ZETA, 4 * index) for index, coefficient in enumerate(value.c)),
        ZERO,
    )


def reduce_z5(value, root):
    answer = 0
    for index, coefficient in enumerate(value.c):
        answer += coefficient.numerator * pow(coefficient.denominator % 11, -1, 11) * pow(root, index, 11)
    return answer % 11


def reduce_pair(point, root):
    return C399.normalize_pair(tuple(reduce_z5(coordinate, root) for coordinate in point), 11)


def reduce_projective(point, root):
    return C399.normalize_mod(tuple(reduce_z5(coordinate, root) for coordinate in point), 11)


def q_to_z5(value):
    return zconst(value[0]) + zconst(value[1]) * PHI


def vec_dot(left, right):
    return sum((a * b for a, b in zip(left, right)), ZERO)


def mat_vec(matrix, vector):
    return tuple(vec_dot(row, vector) for row in matrix)


def normalize_point(point):
    pivot = next(coordinate for coordinate in point if not coordinate.iszero())
    return tuple(OPS["div"](coordinate, pivot) for coordinate in point)


def point_key(point):
    return tuple(tuple((value.numerator, value.denominator) for value in coordinate.c) for coordinate in point)


def matching_image(permutation, matching):
    return tuple(sorted(tuple(sorted((permutation[left], permutation[right]))) for left, right in matching))


def perfect_matchings(vertices):
    vertices = tuple(vertices)
    if not vertices:
        yield ()
        return
    first = vertices[0]
    for offset in range(1, len(vertices)):
        second = vertices[offset]
        rest = vertices[1:offset] + vertices[offset + 1 :]
        for tail in perfect_matchings(rest):
            yield tuple(sorted(((first, second),) + tail))


def matching_orbits(matchings, group):
    unseen = set(matchings)
    answer = []
    while unseen:
        representative = min(unseen)
        orbit = {matching_image(permutation, representative) for permutation in group}
        answer.append(tuple(sorted(orbit)))
        unseen -= orbit
    return tuple(sorted(answer, key=lambda orbit: (len(orbit), orbit[0])))


def one_factorization(matchings):
    counts = Counter(edge for matching in matchings for edge in matching)
    return len(counts) == 66 and set(counts.values()) == {1}


def quotient_vectors(factorization, endpoints, base_product):
    answer = []
    for matching in sorted(factorization):
        product = C406.matching_product(matching, endpoints, 11)
        difference = {
            exponent: (product.get(exponent, 0) - base_product.get(exponent, 0)) % 11
            for exponent in set(product) | set(base_product)
        }
        answer.append(C406.quotient_by_conic(difference, 4, 11))
    return answer


def moment(vectors, degree):
    powers = [C406.symmetric_power(vector, degree, 11) for vector in vectors]
    return [sum(entries) % 11 for entries in zip(*powers)]


def combine(vectors, coefficients):
    return [
        sum(coefficient * vector[index] for coefficient, vector in zip(coefficients, vectors)) % 11
        for index in range(len(vectors[0]))
    ]


def replay():
    qgroup = C442.q_closure(
        [C442.qnormmat(C442.q_refl(root)) for root in C442.q_roots(C442.QPHI)]
    )
    matrices = tuple(
        tuple(tuple(q_to_z5(entry) for entry in row) for row in matrix) for matrix in qgroup
    )
    u = (-PHI, RHO, ONE)
    points = tuple(sorted({normalize_point(mat_vec(matrix, u)) for matrix in matrices}, key=point_key))
    point_index = {point: index for index, point in enumerate(points)}
    group = tuple(
        tuple(point_index[normalize_point(mat_vec(matrix, point))] for point in points)
        for matrix in matrices
    )
    orbits = matching_orbits(tuple(perfect_matchings(range(12))), group)
    six_arc = tuple(tuple(q_to_z5(entry) for entry in point) for point in C442.q_six(C442.QPHI))
    polar = tuple(
        sorted(
            tuple(sorted(index for index, point in enumerate(points) if vec_dot(pole, point).iszero()))
            for pole in six_arc
        )
    )
    assert all(len(pair) == 2 for pair in polar)
    assert tuple(orbit for orbit in orbits if len(orbit) == 1) == ((polar,),)
    candidates = tuple(
        orbit for orbit in orbits if len(orbit) == 10 and one_factorization((polar,) + orbit)
    )
    assert len(candidates) == 4

    kappa_vertices = tuple(
        point_index[normalize_point(tuple(kappa(coordinate) for coordinate in point))] for point in points
    )
    candidate_index = {frozenset(orbit): index for index, orbit in enumerate(candidates)}
    kappa_candidates = tuple(
        candidate_index[frozenset(matching_image(kappa_vertices, matching) for matching in orbit)]
        for orbit in candidates
    )
    pairs = sorted({tuple(sorted((index, image))) for index, image in enumerate(kappa_candidates)})
    assert len(pairs) == 2 and all(left != right for left, right in pairs)

    conic, parameters = C399.conic_parameterization(11)
    conic_index = {point: index for index, point in enumerate(conic)}
    scout = json.loads((HERE / "2026-07-20-c406-matching-orbit-scout.json").read_text())
    h3_record = next(record for record in scout["types"] if record["type"] == "H3")
    finite_base = tuple(tuple(edge) for edge in h3_record["coxeter_invariant_matching"])
    base_product = C406.matching_product(finite_base, parameters, 11)

    moments = {}
    for root_value in (3, 4, 5, 9):
        vertex_map = tuple(conic_index[reduce_projective(point, root_value)] for point in points)
        for index, candidate in enumerate(candidates):
            factorization = frozenset(
                matching_image(vertex_map, matching) for matching in (polar,) + candidate
            )
            vectors = quotient_vectors(factorization, parameters, base_product)
            for degree in (1, 2, 3):
                moments[(root_value, index, degree)] = moment(vectors, degree)

    descended = {}
    for root_value in (3, 4, 5, 9):
        rho = reduce_z5(RHO, root_value)
        weight_basis = []
        for left, right in pairs:
            symmetric = [0] * 4
            antisymmetric = [0] * 4
            symmetric[left] = symmetric[right] = 1
            antisymmetric[left] = rho
            antisymmetric[right] = -rho % 11
            weight_basis.extend((symmetric, antisymmetric))
        for degree in (1, 2, 3):
            vectors = [moments[(root_value, index, degree)] for index in range(4)]
            for basis_index, weights in enumerate(weight_basis):
                descended[(root_value, degree, basis_index)] = combine(vectors, weights)

    assert all(
        descended[(3, degree, basis)] == descended[(4, degree, basis)]
        and descended[(5, degree, basis)] == descended[(9, degree, basis)]
        for degree in (1, 2, 3)
        for basis in range(4)
    )
    columns = {}
    for degree in (1, 2, 3):
        columns[degree] = [
            [
                (left - right) % 11
                for left, right in zip(
                    descended[(3, degree, basis)], descended[(9, degree, basis)]
                )
            ]
            for basis in range(4)
        ]
    lower_matrix = [list(row) for row in zip(*columns[1])] + [list(row) for row in zip(*columns[2])]
    ranks = {str(degree): C406.rank([list(row) for row in zip(*columns[degree])], 11) for degree in (1, 2, 3)}
    assert ranks == {"1": 1, "2": 4, "3": 4}, ranks
    assert C406.rank(lower_matrix, 11) == 4
    assert C406.nullspace(lower_matrix, 11) == []

    certificate = json.loads(CERTIFICATE.read_text())
    assert certificate["schema"] == "c461-four-companion-weight-line-v1"
    assert certificate["moment_maps_mod_11"]["1"]["rank"] == 1
    assert certificate["moment_maps_mod_11"]["2"]["rank"] == 4
    assert certificate["necessary_lower_moment_test"]["rank"] == 4
    assert certificate["necessary_lower_moment_test"]["kernel_dimension"] == 0
    print("C461 REPLAY OK rank(1,2,3)=1,4,4 lower-kernel=0")


if __name__ == "__main__":
    replay()
