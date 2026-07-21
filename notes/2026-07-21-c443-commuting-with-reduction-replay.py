#!/usr/bin/env python3
"""Independent replay for the C443 golden-sheet-lift blocker.

Unlike the primary checker, this works directly in C440's binary icosahedral root frame.  It does
not import the C443 checker or construct the C458 anisotropic-plane bridge.
"""

from __future__ import annotations

import hashlib
import importlib.util
import itertools
import json
from collections import Counter
from fractions import Fraction as F
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-21-c443-commuting-with-reduction.json"


def load_module(stem: str):
    path = HERE / f"{stem}.py"
    spec = importlib.util.spec_from_file_location(f"replay_{stem.replace('-', '_')}", path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C440 = load_module("2026-07-21-c440-conventions-freeze")
C441 = load_module("2026-07-21-c441-vertex-reduction-bijection")
C406 = load_module("2026-07-20-c406-matching-module")
C399 = C406.C399

Z5 = C440.Z5
OPS = C440.ops(Z5)
ZERO = OPS["ZERO"]
ONE = OPS["ONE"]
ZETA = Z5((0, 1, 0, 0))


def zconst(value):
    return Z5((F(value), F(0), F(0), F(0)))


def zpow(value, exponent):
    result = ONE
    while exponent:
        if exponent & 1:
            result = result * value
        value = value * value
        exponent //= 2
    return result


def kappa(value):
    return sum(
        (zconst(coefficient) * zpow(ZETA, 4 * index) for index, coefficient in enumerate(value.c)),
        ZERO,
    )


def reduce_z5(value, root, prime=11):
    answer = 0
    for index, coefficient in enumerate(value.c):
        denominator = coefficient.denominator % prime
        assert denominator
        answer += coefficient.numerator * pow(denominator, -1, prime) * pow(root, index, prime)
    return answer % prime


def reduce_pair(point, root):
    return C399.normalize_pair(tuple(reduce_z5(coordinate, root) for coordinate in point), 11)


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


def is_one_factorization(matchings):
    edge_counts = Counter(edge for matching in matchings for edge in matching)
    return len(edge_counts) == 66 and set(edge_counts.values()) == {1}


def cycle_lengths(permutation):
    unseen = set(range(len(permutation)))
    lengths = []
    while unseen:
        current = min(unseen)
        length = 0
        while current in unseen:
            unseen.remove(current)
            length += 1
            current = permutation[current]
        lengths.append(length)
    return sorted(lengths)


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


def combine(left, right, left_scale=1, right_scale=-1):
    return [
        (left_scale * left[index] + right_scale * right[index]) % 11
        for index in range(len(left))
    ]


def replay():
    m0 = json.loads((HERE / "2026-07-21-c440-conventions-freeze.json").read_text())
    h3 = C441.build_h3(C440, m0)
    roots = tuple(h3["roots"])
    root_index = {root: index for index, root in enumerate(roots)}
    permutations = tuple(
        tuple(root_index[OPS["norm_pt"](OPS["act"](element, root))] for root in roots)
        for element in h3["grp"]
    )
    assert len(set(permutations)) == 60

    matchings = tuple(perfect_matchings(range(12)))
    assert len(matchings) == 10395
    orbits = matching_orbits(matchings, permutations)
    fixed = tuple(orbit for orbit in orbits if len(orbit) == 1)
    assert len(fixed) == 1
    polar = fixed[0][0]
    candidates = tuple(
        orbit for orbit in orbits if len(orbit) == 10 and is_one_factorization((polar,) + orbit)
    )
    assert len(candidates) == 4

    kappa_permutation = tuple(
        root_index[OPS["norm_pt"](tuple(kappa(coordinate) for coordinate in root))] for root in roots
    )
    index_by_orbit = {frozenset(orbit): index for index, orbit in enumerate(candidates)}
    kappa_on_candidates = tuple(
        index_by_orbit[frozenset(matching_image(kappa_permutation, matching) for matching in orbit)]
        for orbit in candidates
    )
    assert cycle_lengths(kappa_on_candidates) == [2, 2]

    scout = json.loads((HERE / "2026-07-20-c406-matching-orbit-scout.json").read_text())
    h3_record = next(record for record in scout["types"] if record["type"] == "H3")
    _conic, parameters = C399.conic_parameterization(11)
    parameter_index = {parameter: index for index, parameter in enumerate(parameters)}
    full_group, psl_group = C406.full_pgl(11, parameters)
    finite_base = tuple(tuple(pair) for pair in h3_record["coxeter_invariant_matching"])
    full_orbit = frozenset(C406.matching_image(element, finite_base) for element in full_group)
    base_sheet = frozenset(C406.matching_image(element, finite_base) for element in psl_group)
    other_sheet = full_orbit - base_sheet
    assert len(full_orbit) == 22 and len(base_sheet) == len(other_sheet) == 11

    root_hit_counts = []
    candidate_hit_counts = [0] * len(candidates)
    reductions = {}
    for root_value in (3, 4, 5, 9):
        vertex_map = tuple(parameter_index[reduce_pair(root, root_value)] for root in roots)
        hits = 0
        for index, candidate in enumerate(candidates):
            reduced = frozenset(
                matching_image(vertex_map, matching) for matching in (polar,) + candidate
            )
            reductions[(root_value, index)] = reduced
            if reduced in (base_sheet, other_sheet):
                hits += 1
                candidate_hit_counts[index] += 1
        root_hit_counts.append(hits)
    assert root_hit_counts == [1, 1, 1, 1]
    assert candidate_hit_counts == [1, 1, 1, 1]

    base_product = C406.matching_product(finite_base, parameters, 11)
    finite_moments = {}
    for root_value in (3, 4, 5, 9):
        for index in range(len(candidates)):
            vectors = quotient_vectors(reductions[(root_value, index)], parameters, base_product)
            for degree in (1, 2, 3):
                finite_moments[(root_value, index, degree)] = moment(vectors, degree)
    target = {}
    for degree in (1, 2, 3):
        target[degree] = combine(
            moment(quotient_vectors(base_sheet, parameters, base_product), degree),
            moment(quotient_vectors(other_sheet, parameters, base_product), degree),
        )
    inv_two = pow(2, -1, 11)
    pairs = sorted({tuple(sorted((index, image))) for index, image in enumerate(kappa_on_candidates)})
    pair_supports = []
    for pair in pairs:
        averaged = {}
        for root_value in (3, 4, 5, 9):
            for degree in (1, 2, 3):
                averaged[(root_value, degree)] = combine(
                    finite_moments[(root_value, pair[0], degree)],
                    finite_moments[(root_value, pair[1], degree)],
                    inv_two,
                    inv_two,
                )
        assert all(averaged[(3, degree)] == averaged[(4, degree)] for degree in (1, 2, 3))
        assert all(averaged[(5, degree)] == averaged[(9, degree)] for degree in (1, 2, 3))
        mu = {degree: combine(averaged[(3, degree)], averaged[(9, degree)]) for degree in (1, 2, 3)}
        assert all(mu[degree] != target[degree] for degree in (1, 2, 3))
        assert any(mu[1])
        pair_supports.append([sum(value != 0 for value in mu[degree]) for degree in (1, 2, 3)])
    pair_supports.sort()

    certificate = json.loads(CERTIFICATE.read_text())
    census = Counter(len(orbit) for orbit in orbits)
    assert certificate["schema"] == "c443-golden-sheet-lift-blocker-v1"
    assert certificate["blocker"]["observed_one_factorizing_size_ten_orbits"] == len(candidates)
    assert certificate["blocker"]["kappa_candidate_cycle_lengths"] == [2, 2]
    assert certificate["blocker"]["kappa_fixed_candidates"] == 0
    assert certificate["blocker"]["candidate_target_hit_counts_across_four_cyclotomic_primes"] == [1, 1, 1, 1]
    assert certificate["geometry"]["matching_orbit_size_census"] == {
        str(size): census[size] for size in sorted(census)
    }
    assert certificate["finite_reductions"]["each_root_has_exactly_one_candidate_hit"]
    assert certificate["finite_reductions"]["no_candidate_hits_more_than_one_root"]
    assert all(
        record["degrees"]["1"]["mu_at_pi_support"] > 0
        and not record["degrees"]["1"]["mu_at_pi_equals_C406_base_minus_outer"]
        for record in certificate["finite_reductions"]["kappa_pair_moment_review"]
    )

    digest = hashlib.sha256(
        json.dumps(
            {
                "candidate_count": len(candidates),
                "candidate_hit_counts": candidate_hit_counts,
                "kappa_cycle_lengths": cycle_lengths(kappa_on_candidates),
                "kappa_pair_mu_supports": pair_supports,
                "orbit_census": dict(sorted(census.items())),
                "root_hit_counts": root_hit_counts,
            },
            separators=(",", ":"),
            sort_keys=True,
        ).encode()
    ).hexdigest()
    print(f"C443 REPLAY OK {digest}")


if __name__ == "__main__":
    replay()
