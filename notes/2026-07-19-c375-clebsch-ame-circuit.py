#!/usr/bin/env python3
"""Exact C375 circuit and A5-equivariance certificate for the Clebsch AME(6,11)."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import sys
import tempfile
from pathlib import Path
from typing import Iterable, Sequence


Q = 11
HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "2026-07-19-c375-clebsch-ame-circuit.json"
C341_PATH = HERE / "2026-07-18-c341-a5-subgroup-decoder.py"
C341_SHA256 = "4419cf398eae700b54e79b8b3ffe237d9ae2ddcefe496fcdadecfc78dddfa5be"

Vector = tuple[int, ...]
Matrix = tuple[Vector, ...]
Matrix2 = tuple[tuple[int, int], tuple[int, int]]
Layout = tuple[tuple[int, int, int], tuple[int, int, int]]


GENERATOR: Matrix = (
    (1, 0, 0, 3, 7, 1),
    (0, 1, 0, 3, 1, 7),
    (0, 0, 1, 1, 10, 10),
)
PARITY_BLOCK: Matrix = tuple(tuple(GENERATOR[i][j] for j in range(3, 6)) for i in range(3))
PAPER_MAP: Matrix = tuple(tuple(PARITY_BLOCK[j][i] for j in range(3)) for i in range(3))
POINTS: tuple[tuple[int, int, int], ...] = (
    (0, 1, 4),
    (0, 1, 7),
    (1, 4, 0),
    (1, 7, 0),
    (1, 0, 3),
    (1, 0, 8),
)


def inv(a: int) -> int:
    if a % Q == 0:
        raise ZeroDivisionError("zero has no inverse")
    return pow(a % Q, Q - 2, Q)


def matmul(left: Matrix, right: Matrix) -> Matrix:
    return tuple(
        tuple(sum(left[i][k] * right[k][j] for k in range(len(right))) % Q for j in range(len(right[0])))
        for i in range(len(left))
    )


def matvec(matrix: Matrix, vector: Sequence[int]) -> Vector:
    return tuple(sum(matrix[i][j] * vector[j] for j in range(len(vector))) % Q for i in range(len(matrix)))


def transpose(matrix: Matrix) -> Matrix:
    return tuple(tuple(matrix[i][j] for i in range(len(matrix))) for j in range(len(matrix[0])))


def det2(matrix: Matrix2) -> int:
    return (matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]) % Q


def det3(matrix: Matrix) -> int:
    a, b, c = matrix
    return (
        a[0] * (b[1] * c[2] - b[2] * c[1])
        - a[1] * (b[0] * c[2] - b[2] * c[0])
        + a[2] * (b[0] * c[1] - b[1] * c[0])
    ) % Q


def inverse3(matrix: Matrix) -> Matrix:
    work = [list(row) + [int(i == j) for j in range(3)] for i, row in enumerate(matrix)]
    for col in range(3):
        pivot = next(row for row in range(col, 3) if work[row][col] % Q)
        work[col], work[pivot] = work[pivot], work[col]
        scale = inv(work[col][col])
        work[col] = [scale * x % Q for x in work[col]]
        for row in range(3):
            if row == col:
                continue
            scale = work[row][col]
            work[row] = [(x - scale * y) % Q for x, y in zip(work[row], work[col])]
    return tuple(tuple(row[3:]) for row in work)


def row_combination(coefficients: Sequence[int], generator: Matrix = GENERATOR) -> Vector:
    return tuple(
        sum(coefficients[i] * generator[i][j] for i in range(len(generator))) % Q
        for j in range(len(generator[0]))
    )


def codewords() -> tuple[Vector, ...]:
    return tuple(row_combination(u) for u in itertools.product(range(Q), repeat=3))


def embed2(matrix: Matrix2, positions: tuple[int, int]) -> Matrix:
    result = [[int(i == j) for j in range(3)] for i in range(3)]
    for i in range(2):
        for j in range(2):
            result[positions[i]][positions[j]] = matrix[i][j] % Q
    return tuple(tuple(row) for row in result)


def criterion_right(matrix: Matrix) -> int:
    g = matrix
    return (
        g[0][0] * g[1][1] * g[2][2]
        + g[0][1] * g[1][2] * g[2][0]
        - g[0][0] * g[1][2] * g[2][1]
        - g[0][1] * g[1][0] * g[2][2]
    ) % Q


def reverse3(matrix: Matrix) -> Matrix:
    return tuple(tuple(matrix[2 - i][2 - j] for j in range(3)) for i in range(3))


def criterion_left(matrix: Matrix) -> int:
    return criterion_right(reverse3(matrix))


def factor_right(matrix: Matrix) -> tuple[Matrix2, Matrix2, Matrix2]:
    """Pozsgay--Wanless (5.1)--(5.12): matrix = C23 B13 A12."""
    g = matrix
    delta = criterion_right(g)
    if delta == 0:
        raise ValueError("right factorization criterion vanishes")
    minor_23 = (g[1][1] * g[2][2] - g[1][2] * g[2][1]) % Q
    a: Matrix2 = (
        (1, g[0][1] * inv(g[0][0]) % Q),
        (
            (g[1][0] * g[2][2] - g[1][2] * g[2][0]) * inv(minor_23) % Q,
            1,
        ),
    )
    b: Matrix2 = (
        (g[0][0], g[0][2]),
        (g[0][0] * (g[1][1] * g[2][0] - g[1][0] * g[2][1]) * inv(delta) % Q, 1),
    )
    c: Matrix2 = (
        (
            (g[0][0] * g[1][1] - g[0][1] * g[1][0]) * minor_23 * inv(delta) % Q,
            g[1][2],
        ),
        (
            (g[0][0] * g[2][1] - g[0][1] * g[2][0]) * minor_23 * inv(delta) % Q,
            g[2][2],
        ),
    )
    assert matmul(matmul(embed2(c, (1, 2)), embed2(b, (0, 2))), embed2(a, (0, 1))) == matrix
    return a, b, c


def factor_left_embedded(matrix: Matrix) -> tuple[Matrix, Matrix, Matrix]:
    """Return full factors L12,L13,L23 with matrix = L12 L13 L23."""
    reverse = ((0, 0, 1), (0, 1, 0), (1, 0, 0))
    a, b, c = factor_right(reverse3(matrix))
    factors = (
        matmul(matmul(reverse, embed2(c, (1, 2))), reverse),
        matmul(matmul(reverse, embed2(b, (0, 2))), reverse),
        matmul(matmul(reverse, embed2(a, (0, 1))), reverse),
    )
    assert matmul(matmul(factors[0], factors[1]), factors[2]) == matrix
    return factors


def is_superregular(matrix: Matrix) -> bool:
    if any(entry == 0 for row in matrix for entry in row):
        return False
    for rows in itertools.combinations(range(3), 2):
        for cols in itertools.combinations(range(3), 2):
            minor: Matrix2 = (
                (matrix[rows[0]][cols[0]], matrix[rows[0]][cols[1]]),
                (matrix[rows[1]][cols[0]], matrix[rows[1]][cols[1]]),
            )
            if det2(minor) == 0:
                return False
    return det3(matrix) != 0


def transition_matrix(target: Sequence[int], source: Sequence[int]) -> Matrix:
    target_projection = tuple(tuple(GENERATOR[row][site] for row in range(3)) for site in target)
    source_projection = tuple(tuple(GENERATOR[row][site] for row in range(3)) for site in source)
    return matmul(target_projection, inverse3(source_projection))


def canonical_layout(target: Iterable[int], source: Iterable[int]) -> Layout:
    pairs = sorted(zip(target, source))
    return tuple(pair[0] for pair in pairs), tuple(pair[1] for pair in pairs)  # type: ignore[return-value]


def layouts() -> tuple[Layout, ...]:
    result = []
    for target in itertools.combinations(range(6), 3):
        complement = tuple(site for site in range(6) if site not in target)
        for source in itertools.permutations(complement):
            result.append((target, source))
    return tuple(result)


def layout_profile(layout: Layout) -> tuple[int, int, int]:
    target, source = layout
    right = left = either = 0
    for ordering in itertools.permutations(range(3)):
        ordered_target = tuple(target[i] for i in ordering)
        ordered_source = tuple(source[i] for i in ordering)
        matrix = transition_matrix(ordered_target, ordered_source)
        assert is_superregular(matrix)
        has_right = criterion_right(matrix) != 0
        has_left = criterion_left(matrix) != 0
        right += has_right
        left += has_left
        either += has_right or has_left
        if has_right:
            factor_right(matrix)
        if has_left:
            factor_left_embedded(matrix)
    return right, left, either


def load_c341():
    assert hashlib.sha256(C341_PATH.read_bytes()).hexdigest() == C341_SHA256
    spec = importlib.util.spec_from_file_location("c341_for_c375", C341_PATH)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def normalize_projective(vector: Sequence[int]) -> tuple[int, int, int]:
    scale = inv(next(entry for entry in vector if entry % Q))
    return tuple(scale * entry % Q for entry in vector)  # type: ignore[return-value]


def induced_permutation(matrix: Matrix) -> tuple[int, ...]:
    point_index = {point: index for index, point in enumerate(POINTS)}
    return tuple(point_index[normalize_projective(matvec(matrix, point))] for point in POINTS)


def sl_lift(matrix: Matrix) -> Matrix:
    # The cube map is bijective on F_11^*: det(matrix)^3 is the unique scale making determinant 1.
    scale = pow(det3(matrix), 3, Q)
    lifted = tuple(tuple(scale * entry % Q for entry in row) for row in matrix)
    assert det3(lifted) == 1
    return lifted


def projective_a5() -> tuple[set[Matrix], set[tuple[int, ...]], bool]:
    c341 = load_c341()
    roots = c341.h3_roots(Q, 8)
    reflection_group = {tuple(tuple(entry for entry in row) for row in matrix) for matrix in c341.reflection_group(Q, roots)}
    reflection_action = {induced_permutation(matrix) for matrix in reflection_group}

    independent_action: set[tuple[int, ...]] = set()
    for permutation in itertools.permutations(range(6)):
        matrix = c341.frame_map(list(POINTS[:4]), [POINTS[permutation[i]] for i in range(4)], Q)
        if all(normalize_projective(c341.mat_vec(matrix, POINTS[i], Q)) == POINTS[permutation[i]] for i in range(6)):
            independent_action.add(permutation)
    assert len(reflection_action) == len(independent_action) == 60
    assert reflection_action == independent_action

    linear_group = {sl_lift(matrix) for matrix in reflection_group}
    assert len(linear_group) == 60
    for left in linear_group:
        for right in linear_group:
            assert matmul(left, right) in linear_group
    return linear_group, reflection_action, True


def monomial_action(matrix: Matrix) -> tuple[tuple[int, ...], tuple[int, ...]]:
    permutation = induced_permutation(matrix)
    scales = []
    for site, point in enumerate(POINTS):
        image = matvec(matrix, point)
        target = POINTS[permutation[site]]
        pivot = next(i for i, entry in enumerate(target) if entry)
        scale = image[pivot] * inv(target[pivot]) % Q
        assert image == tuple(scale * entry % Q for entry in target)
        scales.append(scale)
    return permutation, tuple(scales)


def act_on_word(action: tuple[tuple[int, ...], tuple[int, ...]], word: Vector) -> Vector:
    permutation, scales = action
    result = [0] * 6
    for site in range(6):
        result[permutation[site]] = scales[site] * word[site] % Q
    return tuple(result)


def compose_permutations(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(left[right[i]] for i in range(6))


def inverse_permutation(permutation: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(permutation.index(i) for i in range(6))


def act_on_layout(layout: Layout, permutation: tuple[int, ...]) -> Layout:
    target, source = layout
    return canonical_layout((permutation[i] for i in target), (permutation[i] for i in source))


def layout_orbits(all_layouts: tuple[Layout, ...], action: set[tuple[int, ...]]) -> list[set[Layout]]:
    unseen = set(all_layouts)
    result = []
    while unseen:
        representative = min(unseen)
        orbit = {act_on_layout(representative, permutation) for permutation in action}
        result.append(orbit)
        unseen -= orbit
    return sorted(result, key=lambda orbit: (len(orbit), min(orbit)))


def matching(layout: Layout) -> tuple[tuple[int, int], ...]:
    return tuple(sorted(tuple(sorted(pair)) for pair in zip(*layout)))


def act_on_matching(pairs: tuple[tuple[int, int], ...], permutation: tuple[int, ...]) -> tuple[tuple[int, int], ...]:
    return tuple(sorted(tuple(sorted((permutation[a], permutation[b]))) for a, b in pairs))


def normalizer(action: set[tuple[int, ...]]) -> set[tuple[int, ...]]:
    result = set()
    for permutation in itertools.permutations(range(6)):
        inverse = inverse_permutation(permutation)
        conjugate = {
            compose_permutations(compose_permutations(permutation, element), inverse)
            for element in action
        }
        if conjugate == action:
            result.add(permutation)
    return result


def encode_layout(layout: Layout) -> dict[str, list[int]]:
    return {
        "gate_side_one_based": [site + 1 for site in layout[0]],
        "matched_side_one_based": [site + 1 for site in layout[1]],
    }


def certificate() -> dict[str, object]:
    words = codewords()
    word_set = set(words)
    assert len(word_set) == Q**3

    # Fixed exact three-gate preparation on sites 4,5,6 from Bell pairs (1,4),(2,5),(3,6).
    fixed_a, fixed_b, fixed_c = factor_right(PAPER_MAP)
    assert fixed_a == ((1, 1), (10, 1))
    assert fixed_b == ((3, 1), (7, 1))
    assert fixed_c == ((8, 10), (3, 10))
    fixed_product = matmul(matmul(embed2(fixed_c, (1, 2)), embed2(fixed_b, (0, 2))), embed2(fixed_a, (0, 1)))
    assert fixed_product == PAPER_MAP
    assert all(det2(gate) != 0 and all(entry != 0 for row in gate for entry in row) for gate in (fixed_a, fixed_b, fixed_c))

    circuit_support = {
        tuple(source) + matvec(PAPER_MAP, source)
        for source in itertools.product(range(Q), repeat=3)
    }
    assert circuit_support == word_set

    # The direct systematic Clifford baseline uses one Fourier on each source and all nine nonzero P entries.
    assert all(entry != 0 for row in PARITY_BLOCK for entry in row)

    # Every 3|3 flattening is a permutation unitary; every one-leg choice gives a five-leg encoder.
    flattening_determinants = []
    for source in itertools.combinations(range(6), 3):
        target = tuple(site for site in range(6) if site not in source)
        matrix = transition_matrix(target, source)
        assert is_superregular(matrix)
        flattening_determinants.append(det3(matrix))

    encoder_checks = 0
    for logical_site in range(6):
        remaining = tuple(site for site in range(6) if site != logical_site)
        fibers = [{word for word in words if word[logical_site] == value} for value in range(Q)]
        assert all(len(fiber) == Q**2 for fiber in fibers)
        for erased in itertools.combinations(remaining, 2):
            complement = tuple(site for site in remaining if site not in erased)
            for value, fiber in enumerate(fibers):
                assert len({tuple(word[site] for site in erased) for word in fiber}) == Q**2
                for other in range(value + 1, Q):
                    # Off-diagonal erasure matrix elements would require agreement on the three retained sites.
                    assert {tuple(word[site] for site in complement) for word in fiber}.isdisjoint(
                        {tuple(word[site] for site in complement) for word in fibers[other]}
                    )
            encoder_checks += 1

    linear_group, a5_action, independent_match = projective_a5()
    actions = {matrix: monomial_action(matrix) for matrix in linear_group}
    assert len(set(actions.values())) == 60
    for matrix, action in actions.items():
        assert {act_on_word(action, word) for word in words} == word_set
        for other, other_action in actions.items():
            product = matmul(matrix, other)
            p, scales = action
            op, oscales = other_action
            composed = (
                compose_permutations(p, op),
                tuple(scales[op[i]] * oscales[i] % Q for i in range(6)),
            )
            assert actions[product] == composed

    all_layouts = layouts()
    assert len(all_layouts) == 120
    profiles = {layout: layout_profile(layout) for layout in all_layouts}
    profile_histogram: dict[tuple[int, int, int], int] = {}
    for profile in profiles.values():
        profile_histogram[profile] = profile_histogram.get(profile, 0) + 1
    assert profile_histogram == {(0, 0, 0): 20, (3, 3, 6): 40, (2, 2, 2): 60}
    passing_directed_tests = sum((profile[0] + profile[1]) * count for profile, count in profile_histogram.items())
    passing_layout_orderings = sum(profile[2] * count for profile, count in profile_histogram.items())
    assert passing_directed_tests == 480
    assert passing_layout_orderings == 360

    orbits = layout_orbits(all_layouts, a5_action)
    assert [len(orbit) for orbit in orbits] == [10, 10, 20, 20, 30, 30]
    assert all(len({profiles[layout] for layout in orbit}) == 1 for orbit in orbits)
    orbit_rows = []
    for index, orbit in enumerate(orbits):
        profile = profiles[min(orbit)]
        orbit_rows.append(
            {
                "orbit": index + 1,
                "size": len(orbit),
                "a5_layout_stabilizer_order": 60 // len(orbit),
                "factorization_profile_right_left_union_over_six_pair_orderings": list(profile),
                "factorizable": profile[2] != 0,
                "representative": encode_layout(min(orbit)),
            }
        )
    assert sum(row["size"] for row in orbit_rows if row["factorizable"]) == 100
    assert max(row["a5_layout_stabilizer_order"] for row in orbit_rows if row["factorizable"]) == 3

    fixed_layout: Layout = ((3, 4, 5), (0, 1, 2))
    fixed_orbit = next(orbit for orbit in orbits if fixed_layout in orbit)
    assert len(fixed_orbit) == 20
    assert profiles[fixed_layout] == (3, 3, 6)

    matchings = {matching(layout) for layout in all_layouts}
    assert len(matchings) == 15
    unseen_matchings = set(matchings)
    matching_orbit_sizes = []
    while unseen_matchings:
        representative = min(unseen_matchings)
        orbit = {act_on_matching(representative, permutation) for permutation in a5_action}
        matching_orbit_sizes.append(len(orbit))
        unseen_matchings -= orbit
    assert sorted(matching_orbit_sizes) == [5, 10]

    normalizer_group = normalizer(a5_action)
    assert len(normalizer_group) == 120
    outer = min(normalizer_group - a5_action)
    outer_pairs = []
    for index, orbit in enumerate(orbits):
        image = {act_on_layout(layout, outer) for layout in orbit}
        target_index = next(j for j, candidate in enumerate(orbits) if candidate == image)
        outer_pairs.append((index + 1, target_index + 1))
    assert outer_pairs == [(1, 2), (2, 1), (3, 4), (4, 3), (5, 6), (6, 5)]

    return {
        "schema": "c375-clebsch-ame-circuit-v1",
        "inputs": {
            "field_order": Q,
            "generator_rref": GENERATOR,
            "parity_block_row_convention": PARITY_BLOCK,
            "paper_column_map": PAPER_MAP,
            "c341_dependency_sha256": C341_SHA256,
            "pozsgay_wanless_source": "arXiv:2308.07042v3, equations (3.4), (4.5), and (5.1)-(5.13)",
        },
        "fixed_three_gate_circuit": {
            "initial_bell_pairs_one_based": [[1, 4], [2, 5], [3, 6]],
            "gate_order_one_based": [[4, 5], [4, 6], [5, 6]],
            "linear_permutation_gates": {"A_45": fixed_a, "B_46": fixed_b, "C_56": fixed_c},
            "product_C56_B46_A45": fixed_product,
            "support_rows_checked": len(circuit_support),
            "each_gate_is_four_leg_perfect_tensor": True,
            "arbitrary_two_site_gate_count_after_bell_pairs": 3,
            "arbitrary_two_site_gate_count_from_product_in_source_model": 6,
            "direct_css_baseline": {"one_site_fourier_gates": 3, "weighted_sum_gates": 9},
        },
        "a5_and_layout_census": {
            "linear_a5_order": len(linear_group),
            "projective_action_order": len(a5_action),
            "independent_720_permutation_replay_matches": independent_match,
            "monomial_actions_checked_on_codewords": len(linear_group) * len(words),
            "oriented_bell_triangle_layouts": len(all_layouts),
            "directed_factorization_tests": len(all_layouts) * 6 * 2,
            "passing_directed_factorization_tests": passing_directed_tests,
            "passing_layout_orderings_after_direction_union": passing_layout_orderings,
            "profile_histogram": [
                {"profile_right_left_union": list(profile), "layouts": count}
                for profile, count in sorted(profile_histogram.items())
            ],
            "layout_orbits": orbit_rows,
            "factorizable_layouts": 100,
            "nonfactorizable_layouts": 20,
            "matching_orbit_sizes": sorted(matching_orbit_sizes),
            "fixed_circuit_layout_orbit_size": len(fixed_orbit),
            "fixed_circuit_layout_stabilizer_order": 60 // len(fixed_orbit),
            "largest_factorizable_layout_stabilizer_order": 3,
            "strict_full_a5_fixed_layout_exists": False,
            "normalizer_order": len(normalizer_group),
            "canonical_outer_permutation_zero_based": outer,
            "outer_layout_orbit_pairs": outer_pairs,
        },
        "free_corollaries": {
            "permutation_multiunitary_flattenings_checked": len(flattening_determinants),
            "flattening_determinants": flattening_determinants,
            "explicit_five_leg_encoders": 6,
            "qmds_parameters": "[[5,1,3]]_11",
            "erasure_subsets_checked_per_encoder": 10,
            "encoder_erasure_checks": encoder_checks,
            "grs_encoder_local_unitary_inequivalence_follows_from_c374": True,
        },
        "trusted_boundary": {
            "proves": [
                "the displayed three linear two-site permutation gates prepare the fixed Clebsch state from three Bell pairs",
                "the complete 120-layout linear Pozsgay-Wanless census and its six A5 orbits",
                "no single fixed Bell-triangle layout is strictly A5-invariant; factorable layouts have stabilizer order at most three",
                "A5 nevertheless transports each factorable circuit through an exact covariant orbit family",
                "the six explicit [[5,1,3]]_11 encoder maps and all 3|3 permutation-unitary flattenings",
            ],
            "does_not_prove": [
                "a lower bound against arbitrary nonlinear two-site-unitary circuits outside the Bell-triangle architecture",
                "an ancilla-assisted or coherent-layout A5-equivariant circuit obstruction",
                "minimal cost in a fixed hardware or fault-tolerant gate library",
                "noise, experimental, or holographic performance",
            ],
        },
    }


def canonical_bytes(payload: dict[str, object]) -> bytes:
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def write_output(path: Path) -> tuple[int, str]:
    data = canonical_bytes(certificate())
    path.write_bytes(data)
    return len(data), hashlib.sha256(data).hexdigest()


def check_output() -> tuple[int, str]:
    expected = OUTPUT.read_bytes()
    with tempfile.TemporaryDirectory(prefix="c375-check-") as directory:
        temporary = Path(directory) / OUTPUT.name
        size, digest = write_output(temporary)
        actual = temporary.read_bytes()
    if actual != expected:
        raise SystemExit(f"generated output differs from {OUTPUT}")
    return size, digest


def main() -> None:
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--write", action="store_true")
    group.add_argument("--check", action="store_true")
    args = parser.parse_args()
    size, digest = write_output(OUTPUT) if args.write else check_output()
    print(f"ok: {OUTPUT.name} ({size} bytes, sha256 {digest})")


if __name__ == "__main__":
    main()
