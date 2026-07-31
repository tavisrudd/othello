#!/usr/bin/env python3
"""Exact C729 conference-cut moments and weighted-reflection audit.

The script is deterministic and uses only the Python standard library.  Its
default mode prints the canonical certificate; ``--write`` updates the
adjacent JSON file and ``--check`` compares a fresh computation with it.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter
from fractions import Fraction
from itertools import combinations
from math import comb
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-31-c729-conference-cut-moments.json"
PRIMES = (1_000_000_007, 1_000_000_009)


def determinant_bareiss(matrix: list[list[int]]) -> int:
    a = [row[:] for row in matrix]
    n = len(a)
    sign = 1
    previous = 1
    for k in range(n - 1):
        if a[k][k] == 0:
            pivot_row = next((i for i in range(k + 1, n) if a[i][k]), None)
            if pivot_row is None:
                return 0
            a[k], a[pivot_row] = a[pivot_row], a[k]
            sign = -sign
        pivot = a[k][k]
        for i in range(k + 1, n):
            for j in range(k + 1, n):
                a[i][j] = (a[i][j] * pivot - a[i][k] * a[k][j]) // previous
        previous = pivot
        for i in range(k + 1, n):
            a[i][k] = 0
    return sign * a[-1][-1]


def determinant_mod(matrix: list[list[int]], prime: int) -> int:
    a = [[entry % prime for entry in row] for row in matrix]
    answer = 1
    for k in range(len(a)):
        pivot_row = next((i for i in range(k, len(a)) if a[i][k]), None)
        if pivot_row is None:
            return 0
        if pivot_row != k:
            a[k], a[pivot_row] = a[pivot_row], a[k]
            answer = -answer
        pivot = a[k][k]
        answer = answer * pivot % prime
        inverse = pow(pivot, prime - 2, prime)
        for i in range(k + 1, len(a)):
            factor = a[i][k] * inverse % prime
            for j in range(k, len(a)):
                a[i][j] = (a[i][j] - factor * a[k][j]) % prime
    return answer % prime


def matmul(a: list[list[int]], b: list[list[int]]) -> list[list[int]]:
    return [
        [sum(a[i][k] * b[k][j] for k in range(len(b))) for j in range(len(b[0]))]
        for i in range(len(a))
    ]


def transpose(a: list[list[int]]) -> list[list[int]]:
    return [list(column) for column in zip(*a)]


def identity(n: int) -> list[list[int]]:
    return [[int(i == j) for j in range(n)] for i in range(n)]


def paley_conference(prime_power: int) -> list[list[int]]:
    # The audited higher orders use prime q, so ordinary modular arithmetic
    # suffices.  The order-ten GF(9) example is constructed separately.
    q = prime_power

    def character(x: int) -> int:
        x %= q
        if x == 0:
            return 0
        return 1 if pow(x, (q - 1) // 2, q) == 1 else -1

    return [
        [
            0
            if i == j
            else 1
            if i == 0 or j == 0
            else character((i - 1) - (j - 1))
            for j in range(q + 1)
        ]
        for i in range(q + 1)
    ]


def universal_order_ten() -> list[list[int]]:
    columns = []
    for tail in combinations(range(1, 6), 2):
        half = {0, *tail}
        columns.append([1 if i in half else -1 for i in range(6)])
    gram = matmul(columns, transpose(columns))
    return [
        [(gram[i][j] - 6 * int(i == j)) // 2 for j in range(10)]
        for i in range(10)
    ]


def projective_balanced_masks(n: int) -> list[int]:
    m = n // 2
    return [sum(1 << i for i in (0, *tail)) for tail in combinations(range(1, n), m - 1)]


def cross_block(matrix: list[list[int]], mask: int) -> list[list[int]]:
    n = len(matrix)
    left = [i for i in range(n) if mask >> i & 1]
    right = [i for i in range(n) if not (mask >> i & 1)]
    return [[matrix[i][j] for j in right] for i in left]


def trace_square_gram(block: list[list[int]]) -> tuple[int, int, int]:
    gram = matmul(block, transpose(block))
    gram2 = matmul(gram, gram)
    gram3 = matmul(gram2, gram)
    return (
        sum(gram[i][i] for i in range(len(gram))),
        sum(gram2[i][i] for i in range(len(gram))),
        sum(gram3[i][i] for i in range(len(gram))),
    )


def apply_permutation(mask: int, permutation: tuple[int, ...]) -> int:
    n = len(permutation)
    image = sum(1 << permutation[i] for i in range(n) if mask >> i & 1)
    complement = ((1 << n) - 1) ^ image
    return image if image & 1 else complement


def apply_permutation_oriented(mask: int, permutation: tuple[int, ...]) -> int:
    return sum(1 << permutation[i] for i in range(len(permutation)) if mask >> i & 1)


def pgl_generators(q: int) -> list[tuple[int, ...]]:
    translation = tuple([0] + [((x + 1) % q) + 1 for x in range(q)])
    inversion = tuple(
        [1] + [0 if x == 0 else ((-pow(x, q - 2, q)) % q) + 1 for x in range(q)]
    )
    nonsquare = next(a for a in range(2, q) if pow(a, (q - 1) // 2, q) == q - 1)
    dilation = tuple([0] + [((nonsquare * x) % q) + 1 for x in range(q)])
    return [translation, inversion, dilation]


def oriented_subset_orbits(
    n: int, size: int, generators: list[tuple[int, ...]]
) -> list[tuple[int, set[int]]]:
    unseen = {sum(1 << i for i in subset) for subset in combinations(range(n), size)}
    answer = []
    while unseen:
        representative = min(unseen)
        orbit = {representative}
        frontier = [representative]
        while frontier:
            mask = frontier.pop()
            for generator in generators:
                image = apply_permutation_oriented(mask, generator)
                if image not in orbit:
                    orbit.add(image)
                    frontier.append(image)
        unseen.difference_update(orbit)
        answer.append((representative, orbit))
    return answer


def pgl_orbits(q: int, determinant_by_mask: dict[int, int]) -> list[dict[str, object]]:
    unseen = set(determinant_by_mask)
    generators = pgl_generators(q)
    four_orbits = oriented_subset_orbits(q + 1, 4, generators)
    answer = []
    while unseen:
        representative = min(unseen)
        orbit = {representative}
        frontier = [representative]
        while frontier:
            mask = frontier.pop()
            for generator in generators:
                image = apply_permutation(mask, generator)
                if image not in orbit:
                    orbit.add(image)
                    frontier.append(image)
        unseen.difference_update(orbit)
        values = {determinant_by_mask[mask] for mask in orbit}
        assert len(values) == 1
        oriented_orbit = {representative}
        oriented_frontier = [representative]
        while oriented_frontier:
            mask = oriented_frontier.pop()
            for generator in generators:
                image = apply_permutation_oriented(mask, generator)
                if image not in oriented_orbit:
                    oriented_orbit.add(image)
                    oriented_frontier.append(image)
        projected_orbit = {
            mask if mask & 1 else ((1 << (q + 1)) - 1) ^ mask for mask in oriented_orbit
        }
        assert projected_orbit == orbit
        lambda_three = len(oriented_orbit) * comb((q + 1) // 2, 3) // comb(q + 1, 3)
        assert lambda_three * comb(q + 1, 3) == len(oriented_orbit) * comb((q + 1) // 2, 3)
        triple_counts: Counter[tuple[int, ...]] = Counter()
        for block in oriented_orbit:
            points = [i for i in range(q + 1) if block >> i & 1]
            triple_counts.update(combinations(points, 3))
        assert len(triple_counts) == comb(q + 1, 3)
        assert set(triple_counts.values()) == {lambda_three}

        four_signature = []
        projective_blocks = oriented_orbit | {
            ((1 << (q + 1)) - 1) ^ block for block in oriented_orbit
        }
        projective_four_signature = []
        for four_representative, four_orbit in four_orbits:
            four_half = [
                i - 1 if i else "infinity"
                for i in range(q + 1)
                if four_representative >> i & 1
            ]
            four_signature.append(
                {
                    "blocks_through_representative": sum(
                        (block & four_representative) == four_representative
                        for block in oriented_orbit
                    ),
                    "four_subset_orbit_size": len(four_orbit),
                    "representative_four_subset": four_half,
                }
            )
            projective_four_signature.append(
                sum(
                    (block & four_representative) == four_representative
                    for block in projective_blocks
                )
            )
        half = [i - 1 if i else "infinity" for i in range(q + 1) if representative >> i & 1]
        answer.append(
            {
                "absolute_determinant": values.pop(),
                "complement_closed_oriented_orbit": (((1 << (q + 1)) - 1) ^ representative) in oriented_orbit,
                "four_subset_incidence_signature": four_signature,
                "oriented_block_count": len(oriented_orbit),
                "projective_both_halves_four_subset_signature": projective_four_signature,
                "representative_half": half,
                "size": len(orbit),
                "three_design_lambda": lambda_three,
            }
        )
    return sorted(answer, key=lambda item: (item["absolute_determinant"], item["size"], str(item["representative_half"])))


def matrix_sha256(matrix: list[list[int]]) -> str:
    payload = json.dumps(matrix, separators=(",", ":")).encode()
    return hashlib.sha256(payload).hexdigest()


def audit_order(matrix: list[list[int]], pgl_q: int | None = None) -> dict[str, object]:
    n = len(matrix)
    m = n // 2
    square = matmul(matrix, matrix)
    assert square == [[(n - 1) * int(i == j) for j in range(n)] for i in range(n)]
    determinant_counts: Counter[int] = Counter()
    determinant_by_mask = {}
    determinant_second_moment = 0
    determinant_fourth_moment = 0
    spectral_moment_totals = [0, 0, 0]
    for mask in projective_balanced_masks(n):
        block = cross_block(matrix, mask)
        determinant = determinant_bareiss(block)
        for prime in PRIMES:
            assert determinant % prime == determinant_mod(block, prime)
        absolute = abs(determinant)
        determinant_counts[absolute] += 1
        determinant_by_mask[mask] = absolute
        determinant_second_moment += determinant * determinant
        determinant_fourth_moment += determinant**4
        moments = trace_square_gram(block)
        for i, value in enumerate(moments):
            spectral_moment_totals[i] += value
    cut_count = len(determinant_by_mask)
    assert spectral_moment_totals[0] == cut_count * m * m
    universal_second = Fraction(m * m * (3 * m * m - 6 * m + 2), 2 * m - 3)
    assert Fraction(spectral_moment_totals[1], cut_count) == universal_second
    result: dict[str, object] = {
        "absolute_determinant_distribution": {
            str(value): determinant_counts[value] for value in sorted(determinant_counts)
        },
        "cut_count_mod_complement": cut_count,
        "determinant_fourth_moment": determinant_fourth_moment,
        "determinant_second_moment": determinant_second_moment,
        "matrix_sha256": matrix_sha256(matrix),
        "order": n,
        "spectral_moment_averages": {
            "trace_BBt": str(Fraction(spectral_moment_totals[0], cut_count)),
            "trace_BBt_squared": str(Fraction(spectral_moment_totals[1], cut_count)),
            "trace_BBt_cubed": str(Fraction(spectral_moment_totals[2], cut_count)),
        },
    }
    if pgl_q is not None:
        orbits = pgl_orbits(pgl_q, determinant_by_mask)
        signatures = {
            tuple(orbit["projective_both_halves_four_subset_signature"]) for orbit in orbits
        }
        assert len(signatures) == len(orbits)
        result["four_subset_signature_is_complete_pgl2_orbit_invariant"] = True
        result["pgl2_orbits"] = orbits
    return result


def distance_matrices(adjacency: list[list[int]]) -> tuple[list[list[int]], list[list[int]], list[list[int]], list[list[int]]]:
    n = len(adjacency)
    layers = [[[0] * n for _ in range(n)] for _ in range(4)]
    for start in range(n):
        distance = [-1] * n
        distance[start] = 0
        frontier = [start]
        while frontier:
            vertex = frontier.pop(0)
            for neighbor, joined in enumerate(adjacency[vertex]):
                if joined and distance[neighbor] < 0:
                    distance[neighbor] = distance[vertex] + 1
                    frontier.append(neighbor)
        assert set(distance) == {0, 1, 2, 3}
        for target, value in enumerate(distance):
            layers[value][start][target] = 1
    return tuple(layers)  # type: ignore[return-value]


def weighted_reflection_audit(order_ten: list[list[int]]) -> dict[str, object]:
    extremal = []
    for mask in projective_balanced_masks(10):
        if abs(determinant_bareiss(cross_block(order_ten, mask))) == 48:
            extremal.append(mask)
    assert len(extremal) == 36
    raw = [[1 if mask >> i & 1 else -1 for mask in extremal] for i in range(10)]
    raw_gram = matmul(transpose(raw), raw)
    adjacency = [
        [int(i != j and abs(raw_gram[i][j]) == 6) for j in range(36)] for i in range(36)
    ]
    layers = distance_matrices(adjacency)
    intersection_array = []
    expected = ((0, 0, 5), (1, 0, 4), (1, 2, 2), (4, 1, 0))
    for distance in range(4):
        triples = set()
        for v in range(36):
            for w in range(36):
                if layers[distance][v][w]:
                    counts = [
                        sum(adjacency[w][z] * layers[target][v][z] for z in range(36))
                        for target in range(4)
                    ]
                    triples.add(
                        (
                            counts[distance - 1] if distance else 0,
                            counts[distance],
                            counts[distance + 1] if distance < 3 else 0,
                        )
                    )
        assert triples == {expected[distance]}
        intersection_array.append(expected[distance])

    desired_from_base = (10, -6, 2, -2)
    signs = [desired_from_base[next(d for d in range(4) if layers[d][0][j])] // raw_gram[0][j] for j in range(36)]
    oriented = [[raw[i][j] * signs[j] for j in range(36)] for i in range(10)]
    gram = matmul(transpose(oriented), oriented)
    projector_numerator = [
        [2 * (5 * layers[0][i][j] - 3 * layers[1][i][j] + layers[2][i][j] - layers[3][i][j]) for j in range(36)]
        for i in range(36)
    ]
    assert gram == projector_numerator
    frame = matmul(oriented, transpose(oriented))
    assert frame == [[36 if i == j else -4 for j in range(10)] for i in range(10)]
    k = [[(gram[i][j] - 10 * int(i == j)) // 2 for j in range(36)] for i in range(36)]
    k2 = matmul(k, k)
    assert k2 == [[10 * k[i][j] + 75 * int(i == j) for j in range(36)] for i in range(36)]
    h = [[k[i][j] - 5 * int(i == j) for j in range(36)] for i in range(36)]
    h2 = matmul(h, h)
    assert h2 == [[100 * int(i == j) for j in range(36)] for i in range(36)]
    weights = Counter(abs(k[i][j]) for i in range(36) for j in range(i + 1, 36))
    assert weights == {1: 540, 3: 90}
    trace_powers = []
    power = identity(36)
    for _ in range(4):
        power = matmul(power, k)
        trace_powers.append(sum(power[i][i] for i in range(36)))
    assert trace_powers == [0, 2700, 27000, 472500]
    return {
        "distance_intersection_triples": intersection_array,
        "frame_sha256": matrix_sha256(oriented),
        "large_angle_edges": 90,
        "operator_eigenvalues": {"-5": 27, "15": 9},
        "reflection_eigenvalues": {"-10": 27, "10": 9},
        "sylvester_spectrum": {"-3": 9, "-1": 10, "2": 16, "5": 1},
        "trace_K_powers_1_to_4": trace_powers,
        "unordered_absolute_weight_counts": {"1": 540, "3": 90},
    }


def build_certificate() -> dict[str, object]:
    order_ten = universal_order_ten()
    orders = [
        audit_order(paley_conference(5), pgl_q=5),
        audit_order(order_ten),
        audit_order(paley_conference(13), pgl_q=13),
        audit_order(paley_conference(17), pgl_q=17),
    ]
    return {
        "independent_replay": {
            "method": "every Bareiss determinant checked by modular Gaussian elimination",
            "primes": list(PRIMES),
        },
        "orders": orders,
        "schema": "c729-conference-cut-moments-v3",
        "weighted_order_36": weighted_reflection_audit(order_ten),
    }


def canonical_bytes(certificate: dict[str, object]) -> bytes:
    return (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = canonical_bytes(build_certificate())
    if args.write:
        CERTIFICATE.write_bytes(payload)
    elif args.check:
        if CERTIFICATE.read_bytes() != payload:
            raise SystemExit("certificate mismatch; run with --write and inspect the change")
        print("certificate OK")
    else:
        print(payload.decode(), end="")


if __name__ == "__main__":
    main()
