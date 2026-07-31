#!/usr/bin/env python3
"""Exact C708 certificate: doily codes and the two degree-six actions."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from collections import Counter
from itertools import combinations, permutations, product
from math import comb
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-07-30-c708-doily-codes-and-outer-exchange.json"
C704_SCRIPT = ROOT / "2026-07-30-c704-segre-igusa-operator-shadow.py"
C705_JSON = ROOT / "2026-07-30-c705-adjugate-segre-igusa-polar.json"


def load_c704():
    spec = importlib.util.spec_from_file_location("c704", C704_SCRIPT)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C704 = load_c704()
DUADS = tuple(combinations(range(6), 2))
NODE_PARTITIONS = tuple(
    frozenset(part) for part in combinations(range(6), 3) if 0 in part
)


def perfect_matchings(remaining=frozenset(range(6))):
    if not remaining:
        return ((),)
    first = min(remaining)
    answer = []
    for second in sorted(remaining - {first}):
        pair = (first, second)
        for tail in perfect_matchings(remaining - {first, second}):
            answer.append(tuple(sorted((pair,) + tail)))
    return tuple(answer)


MATCHINGS = perfect_matchings()


def rref(matrix, prime):
    work = [[entry % prime for entry in row] for row in matrix]
    row = 0
    pivots = []
    for column in range(len(work[0])):
        pivot = next(
            (index for index in range(row, len(work)) if work[index][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        scale = pow(work[row][column], -1, prime)
        work[row] = [(scale * entry) % prime for entry in work[row]]
        for index in range(len(work)):
            if index != row and work[index][column]:
                scale = work[index][column]
                work[index] = [
                    (work[index][j] - scale * work[row][j]) % prime
                    for j in range(len(work[0]))
                ]
        pivots.append(column)
        row += 1
    return work[:row], tuple(pivots)


def nullspace(matrix, prime):
    reduced, pivots = rref(matrix, prime)
    free = tuple(i for i in range(len(matrix[0])) if i not in pivots)
    basis = []
    for column in free:
        vector = [0] * len(matrix[0])
        vector[column] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row][column] % prime
        basis.append(vector)
    return basis


def direct_weight_enumerator(generator, prime):
    result = [0] * (len(generator[0]) + 1)
    for coefficients in product(range(prime), repeat=len(generator)):
        word = [
            sum(c * row[j] for c, row in zip(coefficients, generator)) % prime
            for j in range(len(generator[0]))
        ]
        result[sum(entry != 0 for entry in word)] += 1
    return result


def macwilliams(dual_enumerator, prime, dimension):
    length = len(dual_enumerator) - 1
    dual_size = prime ** (length - dimension)
    result = []
    for weight in range(length + 1):
        value = 0
        for dual_weight, multiplicity in enumerate(dual_enumerator):
            krawtchouk = sum(
                (-1) ** j
                * (prime - 1) ** (weight - j)
                * comb(dual_weight, j)
                * comb(length - dual_weight, weight - j)
                for j in range(
                    max(0, weight - (length - dual_weight)),
                    min(weight, dual_weight) + 1,
                )
            )
            value += multiplicity * krawtchouk
        assert value % dual_size == 0
        result.append(value // dual_size)
    return result


def sparse_enumerator(enumerator):
    return {str(weight): count for weight, count in enumerate(enumerator) if count}


def code_record(matrix, prime):
    generator, _ = rref(matrix, prime)
    dual_generator = nullspace(generator, prime)
    dual_enumerator = direct_weight_enumerator(dual_generator, prime)
    enumerator = macwilliams(dual_enumerator, prime, len(generator))
    gram = [
        [sum(a * b for a, b in zip(left, right)) % prime for right in generator]
        for left in generator
    ]
    gram_rank = len(rref(gram, prime)[0])
    return {
        "parameters": [
            len(generator[0]),
            len(generator),
            next(weight for weight, count in enumerate(enumerator) if weight and count),
        ],
        "dual_parameters": [
            len(generator[0]),
            len(dual_generator),
            next(
                weight
                for weight, count in enumerate(dual_enumerator)
                if weight and count
            ),
        ],
        "hull_dimension": len(generator) - gram_rank,
        "weight_enumerator": sparse_enumerator(enumerator),
        "dual_weight_enumerator": sparse_enumerator(dual_enumerator),
    }


def compose(left, right):
    return tuple(left[right[index]] for index in range(len(right)))


def inverse(permutation):
    result = [0] * len(permutation)
    for source, target in enumerate(permutation):
        result[target] = source
    return tuple(result)


def permutation_order(permutation):
    power = tuple(range(len(permutation)))
    for order in range(1, 21):
        power = compose(permutation, power)
        if power == tuple(range(len(permutation))):
            return order
    raise AssertionError("unexpected order")


def cycle_type(permutation):
    seen = set()
    lengths = []
    for start in range(len(permutation)):
        if start in seen:
            continue
        point = start
        length = 0
        while point not in seen:
            seen.add(point)
            length += 1
            point = permutation[point]
        lengths.append(length)
    return tuple(sorted(lengths, reverse=True))


def action_orbits(objects, group, action):
    remaining = set(objects)
    result = []
    while remaining:
        representative = next(iter(remaining))
        orbit = {action(permutation, representative) for permutation in group}
        result.append(orbit)
        remaining -= orbit
    return tuple(result)


def permute_word(word, permutation):
    return sum(
        ((word >> index) & 1) << permutation[index]
        for index in range(len(permutation))
    )


def induced_node_permutation(permutation):
    result = []
    for partition in NODE_PARTITIONS:
        image = frozenset(permutation[index] for index in partition)
        if 0 not in image:
            image = frozenset(set(range(6)) - image)
        result.append(NODE_PARTITIONS.index(image))
    return tuple(result)


def moved_total(total, permutation):
    return C704.total_key(
        tuple(
            tuple(
                sorted(
                    tuple(sorted((permutation[i], permutation[j])))
                    for i, j in matching
                )
            )
            for matching in total
        )
    )


def conference_switch_data(permutation):
    conference = C704.BASE_C
    for global_factor in (1, -1):
        switches = (1,) + tuple(
            global_factor
            * conference[permutation[0]][permutation[index]]
            * conference[0][index]
            for index in range(1, 6)
        )
        if all(
            conference[permutation[i]][permutation[j]]
            == global_factor * switches[i] * switches[j] * conference[i][j]
            for i, j in DUADS
        ):
            return global_factor, switches
    return None


def outer_exchange_record():
    totals = tuple(
        sorted(
            {
                moved_total(C704.BASE_TOTAL, permutation)
                for permutation in permutations(range(6))
            }
        )
    )
    assert len(totals) == 6

    def total_action(permutation):
        return tuple(
            totals.index(moved_total(total, permutation)) for total in totals
        )

    primal_blocks = {
        sum(
            all((a in partition) != (b in partition) for a, b in matching)
            << index
            for index, partition in enumerate(NODE_PARTITIONS)
        )
        for matching in MATCHINGS
    }
    dual_blocks = {
        sum(
            ((a in partition) == (b in partition)) << index
            for index, partition in enumerate(NODE_PARTITIONS)
        )
        for a, b in DUADS
    }
    exchanges = []
    involutions = []
    for permutation in permutations(range(10)):
        if all(permute_word(word, permutation) in dual_blocks for word in primal_blocks):
            exchanges.append(permutation)
            if compose(permutation, permutation) == tuple(range(10)):
                involutions.append(permutation)
    assert len(exchanges) == 720
    assert len(involutions) == 36

    generators = (
        (1, 0, 2, 3, 4, 5),
        (0, 2, 1, 3, 4, 5),
        (0, 1, 3, 2, 4, 5),
        (0, 1, 2, 4, 3, 5),
        (0, 1, 2, 3, 5, 4),
    )
    operator_exchange = tuple(
        exchange
        for exchange in exchanges
        if all(
            compose(
                compose(exchange, induced_node_permutation(generator)),
                inverse(exchange),
            )
            == induced_node_permutation(total_action(generator))
            for generator in generators
        )
    )
    assert len(operator_exchange) == 1
    operator_exchange = operator_exchange[0]
    assert permutation_order(operator_exchange) == 8
    inner_node_actions = {
        induced_node_permutation(permutation): permutation
        for permutation in permutations(range(6))
    }
    exchange_square = compose(operator_exchange, operator_exchange)
    square_preimage = inner_node_actions[exchange_square]
    assert square_preimage == (1, 0, 5, 4, 2, 3)
    assert cycle_type(square_preimage) == (4, 2)

    conference_group = tuple(
        (
            permutation,
            conference_switch_data(permutation),
            induced_node_permutation(permutation),
        )
        for permutation in permutations(range(6))
        if conference_switch_data(permutation) is not None
    )
    assert len(conference_group) == 120
    a5 = tuple(item for item in conference_group if item[1][0] == 1)
    remaining = set(involutions)
    orbits = []
    while remaining:
        representative = next(iter(remaining))
        orbit = {
            compose(compose(node_map, representative), inverse(node_map))
            for _, _, node_map in conference_group
        }
        orbits.append(orbit)
        remaining -= orbit
    assert sorted(map(len, orbits)) == [6, 30]
    golden = next(orbit for orbit in orbits if len(orbit) == 6)
    axis_stabilizers = []
    golden_axis_index = {}
    for polarity in golden:
        stabilizer = tuple(
            permutation
            for permutation, _, node_map in a5
            if compose(compose(node_map, polarity), inverse(node_map)) == polarity
        )
        fixed = tuple(
            axis
            for axis in range(6)
            if all(permutation[axis] == axis for permutation in stabilizer)
        )
        assert len(stabilizer) == 10 and len(fixed) == 1
        axis_stabilizers.append((fixed[0], len(stabilizer)))
        golden_axis_index[polarity] = fixed[0]
        full_stabilizer = {
            permutation
            for permutation, _, node_map in conference_group
            if compose(compose(node_map, polarity), inverse(node_map))
            == polarity
        }
        axis_stabilizer = {
            permutation
            for permutation, _, _ in conference_group
            if permutation[fixed[0]] == fixed[0]
        }
        assert full_stabilizer == axis_stabilizer
        assert len(full_stabilizer) == 20
    assert sorted(axis_stabilizers) == [(axis, 10) for axis in range(6)]
    assert set(golden_axis_index.values()) == set(range(6))

    corrections = {
        polarity: inner_node_actions[
            compose(polarity, inverse(operator_exchange))
        ]
        for polarity in involutions
    }
    identity_six = tuple(range(6))
    for polarity, correction in corrections.items():
        twisted_norm = compose(
            compose(correction, total_action(correction)),
            square_preimage,
        )
        assert twisted_norm == identity_six
        assert compose(
            induced_node_permutation(correction),
            operator_exchange,
        ) == polarity
    correction_types = Counter(cycle_type(value) for value in corrections.values())
    golden_correction_types = Counter(
        cycle_type(corrections[polarity]) for polarity in golden
    )
    assert correction_types == {
        (4, 2): 8,
        (5, 1): 16,
        (3, 3): 4,
        (3, 1, 1, 1): 4,
        (2, 2, 1, 1): 4,
    }
    assert golden_correction_types == {
        (4, 2): 2,
        (5, 1): 2,
        (2, 2, 1, 1): 2,
    }
    base_polarity = involutions[0]
    base_correction = corrections[base_polarity]
    twisted_conjugacy_orbit = {
        compose(
            compose(permutation, base_correction),
            inverse(total_action(permutation)),
        )
        for permutation in permutations(range(6))
    }
    assert twisted_conjugacy_orbit == set(corrections.values())
    twisted_stabilizer = tuple(
        permutation
        for permutation in permutations(range(6))
        if compose(
            compose(permutation, base_correction),
            inverse(total_action(permutation)),
        )
        == base_correction
    )
    assert len(twisted_stabilizer) == 20
    stabilizer_order_distribution = Counter(
        permutation_order(permutation) for permutation in twisted_stabilizer
    )
    assert stabilizer_order_distribution == {1: 1, 2: 5, 4: 10, 5: 4}
    golden_base = next(iter(golden))
    golden_stabilizer = tuple(
        permutation
        for permutation, _, node_map in conference_group
        if compose(
            compose(node_map, golden_base),
            inverse(node_map),
        )
        == golden_base
    )
    assert len(golden_stabilizer) == 20
    golden_axis = golden_axis_index[golden_base]
    golden_d10 = tuple(
        permutation
        for permutation, _, node_map in a5
        if compose(
            compose(node_map, golden_base),
            inverse(node_map),
        )
        == golden_base
    )
    assert len(golden_d10) == 10
    f20_duad_orbits = action_orbits(
        DUADS,
        golden_stabilizer,
        lambda permutation, duad: tuple(
            sorted((permutation[duad[0]], permutation[duad[1]]))
        ),
    )
    f20_matching_orbits = action_orbits(
        MATCHINGS,
        golden_stabilizer,
        lambda permutation, matching: tuple(
            sorted(
                tuple(sorted((permutation[a], permutation[b])))
                for a, b in matching
            )
        ),
    )
    node_orbits = action_orbits(
        tuple(range(10)),
        golden_stabilizer,
        lambda permutation, node: induced_node_permutation(permutation)[node],
    )
    d10_duad_orbits = action_orbits(
        DUADS,
        golden_d10,
        lambda permutation, duad: tuple(
            sorted((permutation[duad[0]], permutation[duad[1]]))
        ),
    )
    d10_matching_orbits = action_orbits(
        MATCHINGS,
        golden_d10,
        lambda permutation, matching: tuple(
            sorted(
                tuple(sorted((permutation[a], permutation[b])))
                for a, b in matching
            )
        ),
    )
    d10_node_orbits = action_orbits(
        tuple(range(10)),
        golden_d10,
        lambda permutation, node: induced_node_permutation(permutation)[node],
    )
    assert sorted(map(len, f20_duad_orbits)) == [5, 10]
    assert sum(
        all(golden_axis in duad for duad in orbit) for orbit in f20_duad_orbits
    ) == 1
    assert sorted(map(len, f20_matching_orbits)) == [5, 10]
    assert sorted(map(len, d10_duad_orbits)) == [5, 5, 5]
    assert sorted(map(len, d10_matching_orbits)) == [5, 5, 5]
    assert sorted(map(len, node_orbits)) == [10]
    assert sorted(map(len, d10_node_orbits)) == [5, 5]
    assert {
        frozenset(golden_base[node] for node in orbit)
        for orbit in d10_node_orbits
    } == {frozenset(orbit) for orbit in d10_node_orbits}
    assert all(
        frozenset(golden_base[node] for node in orbit) != frozenset(orbit)
        for orbit in d10_node_orbits
    )

    base_index = totals.index(C704.total_key(C704.BASE_TOTAL))
    base_stabilizer = tuple(
        permutation
        for permutation in permutations(range(6))
        if moved_total(C704.BASE_TOTAL, permutation)
        == C704.total_key(C704.BASE_TOTAL)
    )
    assert len(base_stabilizer) == 120
    assert {permutation[0] for permutation in base_stabilizer} == set(range(6))
    assert all(total_action(permutation)[base_index] == base_index for permutation in base_stabilizer)

    return {
        "ordinary_axis_action": "natural action on six labels; point stabilizer S5",
        "chart_action": "action on six synthematic totals; total stabilizer S5",
        "base_chart_stabilizer_order": len(base_stabilizer),
        "base_chart_stabilizer_axis_orbit": 6,
        "stabilizer_compatibility": (
            "the induced total-action automorphism sends the outer-S5 "
            "chart stabilizer class to the ordinary point-stabilizer class"
        ),
        "w10_exchange_coset_size": len(exchanges),
        "involutory_polarities": len(involutions),
        "frozen_operator_exchange_on_nodes": list(operator_exchange),
        "frozen_operator_exchange_order": permutation_order(operator_exchange),
        "frozen_exchange_square_inner_preimage": list(square_preimage),
        "frozen_exchange_square_cycle_type": list(cycle_type(square_preimage)),
        "involutory_normalization_count": len(involutions),
        "involutory_normalization_equation": (
            "k*alpha(k)=h^-1, where h=(0 1)(2 5 3 4) is the "
            "inner preimage of the frozen exchange square"
        ),
        "normalizing_inner_correction_cycle_types": {
            ",".join(map(str, kind)): count
            for kind, count in sorted(correction_types.items())
        },
        "twisted_conjugacy_orbit_size": len(twisted_conjugacy_orbit),
        "twisted_conjugacy_stabilizer_order": len(twisted_stabilizer),
        "twisted_conjugacy_stabilizer": "F20=C5 semidirect C4=AGL(1,5)",
        "twisted_stabilizer_element_orders": {
            str(order): count
            for order, count in sorted(stabilizer_order_distribution.items())
        },
        "polarity_count_orbit_stabilizer": "36=720/20",
        "conference_orbit_sizes_on_involutions": sorted(map(len, orbits)),
        "golden_normalizations": len(golden),
        "golden_count_orbit_stabilizer": "6=120/20",
        "golden_axis_indexing": (
            "the conference-S5 stabilizer of each golden polarity equals "
            "the stabilizer of its indexed axis; both are F20"
        ),
        "golden_f20_orbits": {
            "duads": [5, 10],
            "synthemes": [5, 10],
            "nodes": [10],
        },
        "golden_d10_orbits": {
            "subgroup": "D10=F20 intersection A5",
            "duads": [5, 5, 5],
            "duad_meaning": "axis star, pentagon sides, pentagram diagonals",
            "synthemes": [5, 5, 5],
            "nodes": [5, 5],
            "polarity_on_node_orbits": "exchanges the two 5-orbits",
            "orientation_reversal": (
                "the F20 minus D10 coset merges sides and diagonals"
            ),
        },
        "golden_inner_correction_cycle_types": {
            ",".join(map(str, kind)): count
            for kind, count in sorted(golden_correction_types.items())
        },
        "verdict": (
            "positive outer exchange of the two degree-six representations; "
            "the operator alone does not select an involution.  Its frozen "
            "lexicographic marking is order 8, all 36 involutory normalizations "
            "remain possible, and the conference marking cuts these to the "
            "axis-indexed orbit of 6"
        ),
    }


def build_certificate():
    context_point = [
        [int(duad in matching) for duad in DUADS] for matching in MATCHINGS
    ]
    grid_point = [
        [
            int((duad[0] in partition) != (duad[1] in partition))
            for duad in DUADS
        ]
        for partition in NODE_PARTITIONS
    ]
    grid_context = [
        [
            int(
                all(
                    (a in partition) != (b in partition)
                    for a, b in matching
                )
            )
            for matching in MATCHINGS
        ]
        for partition in NODE_PARTITIONS
    ]
    matrices = {
        "context_point": context_point,
        "grid_point": grid_point,
        "grid_context": grid_context,
    }
    records = {
        str(prime): {
            name: code_record(matrix, prime) for name, matrix in matrices.items()
        }
        for prime in (2, 3, 5)
    }
    subspace_intersections = {}
    for prime in (2, 3, 5):
        dimensions = {
            name: len(rref(matrix, prime)[0]) for name, matrix in matrices.items()
        }
        subspace_intersections[str(prime)] = {
            f"{left_name}_and_{right_name}": (
                dimensions[left_name]
                + dimensions[right_name]
                - len(rref(left + right, prime)[0])
            )
            for left_name, left in matrices.items()
            for right_name, right in matrices.items()
            if left_name < right_name
        }
    assert subspace_intersections == {
        "2": {
            "context_point_and_grid_context": 0,
            "context_point_and_grid_point": 5,
            "grid_context_and_grid_point": 0,
        },
        "3": {
            "context_point_and_grid_context": 6,
            "context_point_and_grid_point": 9,
            "grid_context_and_grid_point": 5,
        },
        "5": {
            "context_point_and_grid_context": 5,
            "context_point_and_grid_point": 10,
            "grid_context_and_grid_point": 5,
        },
    }
    orthogonal_pairs = {}
    for prime in (2, 3, 5):
        orthogonal_pairs[str(prime)] = [
            [left_name, right_name]
            for left_name, left in matrices.items()
            for right_name, right in matrices.items()
            if all(
                sum(a * b for a, b in zip(x, y)) % prime == 0
                for x in left
                for y in right
            )
        ]
    assert orthogonal_pairs == {
        "2": [["grid_context", "grid_context"]],
        "3": [],
        "5": [],
    }
    c705 = json.loads(C705_JSON.read_text())
    characteristic_ranks = c705["jacobian_adjugate"][
        "characteristic_rank_witnesses"
    ]
    return {
        "schema": "c708-doily-codes-and-outer-exchange-v1",
        "coordinate_sets": {
            "points": "15 duads",
            "contexts": "15 synthemes",
            "grids": "10 unordered 3+3 partitions",
        },
        "codes": records,
        "rowspace_intersection_dimensions": subspace_intersections,
        "permutation_automorphism_group": {
            "order": 720,
            "abstract_group": "S6",
            "justification": (
                "minimum supports reconstruct respectively synthemes, six "
                "stars, 4-cycles of K6, or the ten-grid incidence; each has "
                "full coordinate automorphism group S6"
            ),
        },
        "signed_lifts": (
            "Pauli and Clebsch context signs are row scalings followed by "
            "the frozen point rephasing, hence give the same or monomially "
            "equivalent codes over every odd field; in characteristic 2 "
            "all signs coincide"
        ),
        "orthogonal_rowspace_pairs": orthogonal_pairs,
        "css": {
            "only_nonzero_family_pair": "binary grid_context is self-orthogonal",
            "parameters": "[[15,5,3]]_2",
            "distance_reason": (
                "grid_context is [15,5,6] and its dual is an isodual "
                "copy of the binary context_point [15,10,3] code"
            ),
            "novelty_boundary": "standard incidence-derived CSS code; no novelty claim",
        },
        "symplectic": (
            "the CSS check matrix diag(grid_context,grid_context) is "
            "symplectically self-orthogonal; no odd-characteristic member "
            "of this incidence family is self-orthogonal"
        ),
        "c705_characteristic_ranks": characteristic_ranks,
        "rank_comparison": {
            "2": (
                "all incidence matrices drop, but only to ranks 10,5,5 "
                "while G,A drop to 1,0: incidence-only overlap, not an explanation"
            ),
            "3": (
                "grid_point alone drops to rank 9; context_point and "
                "grid_context stay rank 10 while G,A have rank 3: unrelated "
                "scalar/compound degeneration"
            ),
            "5": (
                "all three codes have rank 10 and zero hull (context_point "
                "equals grid_point, while grid_context meets it in dimension "
                "5) and G,A retain rank 4: the bad prime is "
                "sign-lift/golden-splitting arithmetic, not incidence"
            ),
        },
        "outer_exchange": outer_exchange_record(),
    }


def canonical_bytes(data):
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write or --check")
    encoded = canonical_bytes(build_certificate())
    if args.write:
        OUTPUT.write_bytes(encoded)
    else:
        assert OUTPUT.read_bytes() == encoded
    print(
        json.dumps(
            {
                "certificate": OUTPUT.name,
                "bytes": len(encoded),
                "sha256": hashlib.sha256(encoded).hexdigest(),
                "status": "written" if args.write else "verified",
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
