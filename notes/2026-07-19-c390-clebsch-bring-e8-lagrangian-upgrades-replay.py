#!/usr/bin/env python3
"""Independent replay of the C390 finite certificate.

This file imports neither the C390 primary checker nor its helpers.  It uses the
independently written C379 formula replay for the q=11 group action.
"""

from collections import Counter, defaultdict
from fractions import Fraction
import hashlib
import importlib.util
import itertools
import json
import math
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
RESULT = ROOT / "notes/2026-07-19-c390-clebsch-bring-e8-lagrangian-upgrades.json"
C379_JSON = ROOT / "notes/2026-07-19-c379-clebsch-deep-hole-extension.json"
C379_REPLAY = ROOT / "notes/2026-07-19-c379-clebsch-deep-hole-extension-replay.py"


def vectors_with_square_sum(total: int, length: int, parity: int):
    values = [value for value in range(-int(math.sqrt(total)), int(math.sqrt(total)) + 1) if value % 2 == parity]

    def visit(prefix, remaining):
        if len(prefix) == length:
            if remaining == 0 and sum(prefix) % 4 == 0:
                yield tuple(prefix)
            return
        for value in values:
            square = value * value
            if square <= remaining:
                yield from visit(prefix + [value], remaining - square)

    yield from visit([], total)


def solve(matrix, vector):
    n = len(vector)
    work = [[Fraction(matrix[row][column]) for column in range(n)] + [Fraction(vector[row])] for row in range(n)]
    for column in range(n):
        pivot = next(row for row in range(column, n) if work[row][column])
        work[column], work[pivot] = work[pivot], work[column]
        divisor = work[column][column]
        work[column] = [entry / divisor for entry in work[column]]
        for row in range(n):
            if row != column:
                multiple = work[row][column]
                work[row] = [a - multiple * b for a, b in zip(work[row], work[column])]
    answer = tuple(row[-1] for row in work)
    assert all(value.denominator == 1 for value in answer)
    return tuple(int(value) for value in answer)


def replay_e8(expected):
    roots = set(vectors_with_square_sum(8, 8, 0)) | set(vectors_with_square_sum(8, 8, 1))
    norm_four = set(vectors_with_square_sum(16, 8, 0)) | set(vectors_with_square_sum(16, 8, 1))
    assert (len(roots), len(norm_four)) == (240, 2160)
    basis = []
    for i in range(1, 7):
        vector = [0] * 8
        vector[i], vector[i + 1] = 2, -2
        basis.append(vector)
    basis.extend(([0, 0, 0, 0, 0, 0, 2, 2], [1] * 8))
    matrix = [[basis[column][row] for column in range(8)] for row in range(8)]
    cosets = defaultdict(int)
    for vector in norm_four:
        cosets[tuple(value % 2 for value in solve(matrix, vector))] += 1
    assert len(cosets) == 135 and set(cosets.values()) == {16}
    w = (4, 0, 0, 0, 0, 0, 0, 0)
    pairings = Counter(sum(a * b for a, b in zip(root, w)) // 4 for root in roots)
    assert pairings == Counter({0: 84, 1: 64, -1: 64, 2: 14, -2: 14})
    cap = {root for root in roots if sum(a * b for a, b in zip(root, w)) == 8}
    pairs = {tuple(sorted((root, tuple(a - b for a, b in zip(w, root))))) for root in cap}
    assert len(pairs) == 7
    assert expected["root_count"] == 240
    assert expected["norm_four_count"] == 2160
    assert expected["nonzero_singular_coset_count"] == 135
    assert expected["orthogonal_decomposition_count"] == 7


def components(left, right):
    adjacency = [set() for _ in range(12)]
    for a, b in left + right:
        adjacency[a].add(b)
        adjacency[b].add(a)
    count = 0
    unseen = set(range(12))
    while unseen:
        count += 1
        stack = [unseen.pop()]
        while stack:
            for neighbour in adjacency[stack.pop()]:
                if neighbour in unseen:
                    unseen.remove(neighbour)
                    stack.append(neighbour)
    return count


def replay_matchings(expected):
    frozen = json.loads(C379_JSON.read_text())
    points = [tuple(point) for point in frozen["deep_hole_conic"]]
    index = {point: i for i, point in enumerate(points)}

    def matching(raw):
        return tuple(sorted(tuple(sorted((index[tuple(a)], index[tuple(b)]))) for a, b in raw))

    sheets = [
        tuple(matching(raw) for raw in frozen["one_factorization_biplane"][key])
        for key in ("tau8_sheet_matchings", "tau4_sheet_matchings")
    ]
    matchings = sheets[0] + sheets[1]

    # Independent coordinates on even-weight F2^12/<1>: complement to make bit 11 zero,
    # then bits 0..9 are free and bit 10 is forced by even parity.
    def coordinate(mask):
        if mask & (1 << 11):
            mask ^= (1 << 12) - 1
        return mask & ((1 << 10) - 1)

    def edge_vector(edge):
        return coordinate((1 << edge[0]) | (1 << edge[1]))

    def span(rows):
        values = {0}
        for row in rows:
            values |= {value ^ row for value in tuple(values)}
        return frozenset(values)

    spaces = [span(edge_vector(edge) for edge in item) for item in matchings]
    assert len(set(spaces)) == 22 and {len(space) for space in spaces} == {32}
    spectrum = Counter()
    for i, j in itertools.combinations(range(22), 2):
        dimension = int(math.log2(len(spaces[i] & spaces[j])))
        cycles = components(matchings[i], matchings[j])
        assert dimension == cycles - 1
        spectrum[(dimension, cycles)] += 1
    encoded = {f"dim={d},cycles={c}": n for (d, c), n in sorted(spectrum.items())}
    assert encoded == expected["intersection_cycle_spectrum"]
    perfect = []
    cycle_spectra = []
    for sheet in sheets:
        counts = Counter(components(left, right) for left, right in itertools.combinations(sheet, 2))
        perfect.append(set(counts) == {1})
        cycle_spectra.append({str(key): value for key, value in sorted(counts.items())})
    assert perfect == expected["factorization_is_perfect"]
    assert cycle_spectra == expected["factorization_cycle_spectra"]


def replay_groups(expected):
    spec = importlib.util.spec_from_file_location("c379_independent", C379_REPLAY)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    conic = frozenset(point for point in module.projective_points() if module.dot(point, point) == 0)
    parent = frozenset(module.six_points(8))
    a5 = module.a5(8)
    golden_j = ((1, 0, 0), (0, 0, -1), (0, -1, 0))
    pgl = module.closure(list(a5) + [golden_j])
    psl = module.closure(list(a5) + [module.normm(module.mm(module.mm(golden_j, element), golden_j)) for element in a5])
    parent_matching = module.obstruction_matching(parent, conic)
    edge = min(parent_matching, key=lambda pair: tuple(sorted(pair)))
    point = min(edge)
    parent_stabilizer = {g for g in pgl if module.image(g, parent) == parent}
    edge_stabilizer = {g for g in parent_stabilizer if frozenset(module.normalize(module.mv(g, p)) for p in edge) == edge}
    point_stabilizer = {g for g in edge_stabilizer if module.normalize(module.mv(g, point)) == point}
    assert [len(group) for group in (point_stabilizer, edge_stabilizer, parent_stabilizer, psl, pgl)] == [5, 10, 60, 660, 1320]
    assert expected["orders"] == {"C5": 5, "D10": 10, "A5": 60, "PSL2_11": 660, "PGL2_11": 1320}
    assert expected["homogeneous_space_sizes"] == {"PGL2_11/C5": 264, "PGL2_11/D10": 132, "PGL2_11/A5": 22}


def replay_triality(expected):
    def expand(value):
        return value | ((value.bit_count() & 1) << 4)

    def w_action(permutation, value):
        source = expand(value)
        target = 0
        for old, new in enumerate(permutation):
            if source & (1 << old):
                target ^= 1 << new
        return target & 15

    def s5_action(permutation, value):
        return w_action(permutation, value & 15) | (w_action(permutation, value >> 4) << 4)

    def q(value):
        return (expand(value & 15) & expand(value >> 4)).bit_count() & 1

    permutations = list(itertools.permutations(range(5)))
    unseen = set(range(256))
    orbits = []
    while unseen:
        representative = min(unseen)
        orbit = frozenset(s5_action(permutation, representative) for permutation in permutations)
        unseen -= orbit
        orbits.append((q(representative), orbit))
    spectrum = Counter((parity, len(orbit)) for parity, orbit in orbits)
    assert spectrum == Counter({(0, 5): 3, (0, 10): 3, (0, 30): 3, (1, 20): 3, (0, 1): 1, (1, 60): 1})

    gl2 = []
    for a, b, c, d in itertools.product((0, 1), repeat=4):
        if (a * d + b * c) % 2 == 1:
            gl2.append((a, b, c, d))
    assert len(gl2) == 6

    def multiplicity_action(matrix, value):
        a, b, c, d = matrix
        x, y = value & 15, value >> 4
        return ((a * x) ^ (b * y)) | (((c * x) ^ (d * y)) << 4)

    assert all(q(multiplicity_action(matrix, value)) == q(value) for matrix in gl2 for value in range(256))
    orbit_index = {value: index for index, (_, orbit) in enumerate(orbits) for value in orbit}
    induced = {
        tuple(orbit_index[multiplicity_action(matrix, min(orbit))] for _, orbit in orbits)
        for matrix in gl2
    }
    assert len(induced) == 6
    for parity, size in ((0, 5), (0, 10), (0, 30), (1, 20)):
        indices = [i for i, (p, orbit) in enumerate(orbits) if (p, len(orbit)) == (parity, size)]
        assert len({tuple(permutation[i] for i in indices) for permutation in induced}) == 6
    assert expected["orthogonal_centralizer_order"] == 6
    assert expected["normalizer_order"] == 720
    assert expected["simultaneously_permutes_all_four_orbit_triples"] is True


def replay_golden(expected):
    def multiply(left, right):
        result = [0] * (len(left) + len(right) - 1)
        for i, a in enumerate(left):
            for j, b in enumerate(right):
                result[i + j] += a * b
        return result

    factors = ([0, 0, 0, 4], [-1, -1, 1], [1, -3, 4, -2, 1], [1, 2, 4, 3, 1])
    expanded = [1]
    for factor in factors:
        expanded = multiply(expanded, factor)
    assert expanded == expected["common_discriminant_coefficients_increasing_degree"]
    roots = []
    for value in range(11):
        evaluation = 0
        for coefficient in reversed(expanded):
            evaluation = (evaluation * value + coefficient) % 11
        if evaluation == 0:
            roots.append(value)
    assert roots == list(range(11))
    assert [value for value in range(11) if (value * value - value - 1) % 11 == 0] == [4, 8]
    assert expected["finite_branch_support"] == roots


def main():
    result = json.loads(RESULT.read_text())
    replay_e8(result["e8_norm_four"])
    replay_matchings(result["matching_lagrangians"])
    replay_groups(result["induced_homogeneous_spaces"])
    replay_triality(result["bring_theta_centralizer"])
    replay_golden(result["golden_reduction"])
    print(f"independently replayed {RESULT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
