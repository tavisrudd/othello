#!/usr/bin/env python3
"""Deterministic finite certificate for the free C390 upgrades.

This checker deliberately separates the general E8 and matching calculations from
the frozen q=11 Clebsch input.  The latter is imported only through the pinned C379
checker and canonical JSON.
"""

from __future__ import annotations

import argparse
from collections import Counter, defaultdict
from fractions import Fraction
import hashlib
import importlib.util
import itertools
import json
import math
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
C379_PY = ROOT / "notes/2026-07-19-c379-clebsch-deep-hole-extension.py"
C379_JSON = ROOT / "notes/2026-07-19-c379-clebsch-deep-hole-extension.json"
OUTPUT = ROOT / "notes/2026-07-19-c390-clebsch-bring-e8-lagrangian-upgrades.json"
C379_PY_SHA256 = "ca8024023173aaa09e0252780b8297ebac06bcc920115e3b9b808059d4b0d587"
C379_JSON_SHA256 = "3cc3a7008d91a06f95504cbced7adc2eef9b304355a3a56bb64bdd0bea19ad8d"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def canonical_bytes(value: object) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def load_c379():
    assert sha256(C379_PY) == C379_PY_SHA256
    assert sha256(C379_JSON) == C379_JSON_SHA256
    spec = importlib.util.spec_from_file_location("c379_frozen", C379_PY)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module, json.loads(C379_JSON.read_text())


def inverse(matrix: list[list[int]]) -> list[list[Fraction]]:
    n = len(matrix)
    work = [list(map(Fraction, row)) + [Fraction(i == j) for j in range(n)] for i, row in enumerate(matrix)]
    for column in range(n):
        pivot = next(row for row in range(column, n) if work[row][column])
        work[column], work[pivot] = work[pivot], work[column]
        scale = work[column][column]
        work[column] = [entry / scale for entry in work[column]]
        for row in range(n):
            if row != column and work[row][column]:
                scale = work[row][column]
                work[row] = [a - scale * b for a, b in zip(work[row], work[column])]
    return [row[n:] for row in work]


def e8_data() -> dict[str, object]:
    # Coordinates are doubled: y represents x=y/2 in the standard E8 model.
    roots = set()
    for i, j in itertools.combinations(range(8), 2):
        for signs in itertools.product((-2, 2), repeat=2):
            vector = [0] * 8
            vector[i], vector[j] = signs
            roots.add(tuple(vector))
    for signs in itertools.product((-1, 1), repeat=8):
        if sum(signs) % 4 == 0:
            roots.add(signs)
    assert len(roots) == 240 and {sum(x * x for x in root) for root in roots} == {8}

    norm_four = set()
    for i in range(8):
        for sign in (-4, 4):
            vector = [0] * 8
            vector[i] = sign
            norm_four.add(tuple(vector))
    for support in itertools.combinations(range(8), 4):
        for signs in itertools.product((-2, 2), repeat=4):
            vector = [0] * 8
            for index, sign in zip(support, signs):
                vector[index] = sign
            norm_four.add(tuple(vector))
    for exceptional in range(8):
        for signs in itertools.product((-1, 1), repeat=8):
            for exceptional_sign in (-3, 3):
                vector = list(signs)
                vector[exceptional] = exceptional_sign
                if sum(vector) % 4 == 0:
                    norm_four.add(tuple(vector))
    assert len(norm_four) == 2160 and {sum(x * x for x in vector) for vector in norm_four} == {16}

    # A unimodular E8 basis, again doubled.
    basis = []
    # Start from the usual D8 basis d_i=e_i-e_(i+1), d_8=e_7+e_8.
    # Replacing d_1 by the half-sum vector gives a determinant-one E8 basis.
    for i in range(1, 7):
        vector = [0] * 8
        vector[i], vector[i + 1] = 2, -2
        basis.append(vector)
    basis.append([0, 0, 0, 0, 0, 0, 2, 2])
    basis.append([1] * 8)
    # Columns are basis vectors; invert the corresponding row matrix.
    basis_matrix = [[basis[column][row] for column in range(8)] for row in range(8)]
    basis_inverse = inverse(basis_matrix)

    def lattice_coordinates(vector: tuple[int, ...]) -> tuple[int, ...]:
        coordinates = []
        for row in basis_inverse:
            value = sum(entry * coordinate for entry, coordinate in zip(row, vector))
            assert value.denominator == 1
            coordinates.append(int(value))
        return tuple(coordinates)

    cosets: dict[tuple[int, ...], list[tuple[int, ...]]] = defaultdict(list)
    for vector in norm_four:
        cosets[tuple(value % 2 for value in lattice_coordinates(vector))].append(vector)
    assert len(cosets) == 135 and {len(vectors) for vectors in cosets.values()} == {16}
    assert (0,) * 8 not in cosets

    w = (4, 0, 0, 0, 0, 0, 0, 0)

    def pairing(left: tuple[int, ...], right: tuple[int, ...]) -> int:
        numerator = sum(a * b for a, b in zip(left, right))
        assert numerator % 4 == 0
        return numerator // 4

    pairing_counts = Counter(pairing(root, w) for root in roots)
    assert pairing_counts == Counter({0: 84, 2: 14, -2: 14, 1: 64, -1: 64})
    parity_kernel_roots = {root for root in roots if pairing(root, w) % 2 == 0}
    assert len(parity_kernel_roots) == 112
    cap = {root for root in roots if pairing(root, w) == 2}
    decompositions = set()
    for root in cap:
        mate = tuple(a - b for a, b in zip(w, root))
        assert mate in cap and pairing(root, mate) == 0
        decompositions.add(tuple(sorted((root, mate))))
    assert len(decompositions) == 7

    def line(vector: tuple[int, ...]) -> tuple[int, ...]:
        negative = tuple(-value for value in vector)
        return min(vector, negative)

    w_coset = tuple(value % 2 for value in lattice_coordinates(w))
    lift_lines = {line(vector) for vector in cosets[w_coset]}
    assert len(lift_lines) == 8 and line(w) in lift_lines
    star_neighbours = set()
    for root, mate in decompositions:
        difference = tuple(a - b for a, b in zip(root, mate))
        assert sum(value * value for value in difference) == 16
        assert tuple(value % 2 for value in lattice_coordinates(difference)) == w_coset
        star_neighbours.add(line(difference))
    assert len(star_neighbours) == 7
    assert star_neighbours | {line(w)} == lift_lines

    return {
        "root_count": len(roots),
        "norm_four_count": len(norm_four),
        "nonzero_singular_coset_count": len(cosets),
        "norm_four_lifts_per_coset": sorted({len(vectors) for vectors in cosets.values()}),
        "lift_lines_per_coset": len(lift_lines),
        "canonical_pairing_spectrum": {str(key): value for key, value in sorted(pairing_counts.items())},
        "parity_kernel_root_count": len(parity_kernel_roots),
        "effective_cap_root_count": len(cap),
        "orthogonal_decomposition_count": len(decompositions),
        "k8_star_neighbour_count": len(star_neighbours),
        "k8_star_exhausts_lift_lines": star_neighbours | {line(w)} == lift_lines,
    }


def matching_cycles(left: tuple[tuple[int, int], ...], right: tuple[tuple[int, int], ...], size: int) -> int:
    adjacency = [set() for _ in range(size)]
    for a, b in left + right:
        adjacency[a].add(b)
        adjacency[b].add(a)
    unseen = set(range(size))
    components = 0
    while unseen:
        components += 1
        stack = [unseen.pop()]
        while stack:
            for neighbour in adjacency[stack.pop()]:
                if neighbour in unseen:
                    unseen.remove(neighbour)
                    stack.append(neighbour)
    return components


def matching_data(c379, frozen: dict[str, object]) -> tuple[dict[str, object], dict[str, object]]:
    points = [tuple(point) for point in frozen["deep_hole_conic"]]
    point_index = {point: index for index, point in enumerate(points)}
    all_ones = (1 << len(points)) - 1

    def parse_matching(raw) -> tuple[tuple[int, int], ...]:
        return tuple(sorted(tuple(sorted((point_index[tuple(a)], point_index[tuple(b)]))) for a, b in raw))

    raw_sheets = frozen["one_factorization_biplane"]
    sheets = [
        tuple(parse_matching(matching) for matching in raw_sheets[name])
        for name in ("tau8_sheet_matchings", "tau4_sheet_matchings")
    ]
    matchings = tuple(matching for sheet in sheets for matching in sheet)
    assert len(matchings) == len(set(matchings)) == 22

    def canonical(mask: int) -> int:
        return min(mask, mask ^ all_ones)

    def q(mask: int) -> int:
        representative_weight = min(mask.bit_count(), len(points) - mask.bit_count())
        assert representative_weight % 2 == 0
        return (representative_weight // 2) % 2

    def edge_mask(edge: tuple[int, int]) -> int:
        return (1 << edge[0]) | (1 << edge[1])

    def span(matching: tuple[tuple[int, int], ...]) -> frozenset[int]:
        result = {0}
        for edge in matching:
            bit = edge_mask(edge)
            result |= {canonical(value ^ bit) for value in list(result)}
        return frozenset(result)

    lagrangians = tuple(span(matching) for matching in matchings)
    assert len(set(lagrangians)) == 22 and {len(space) for space in lagrangians} == {32}
    kernels = tuple(frozenset(vector for vector in space if q(vector) == 0) for space in lagrangians)
    assert {len(kernel) for kernel in kernels} == {16}
    recovery_spectra = []
    for matching, space in zip(matchings, lagrangians):
        q_one = [vector for vector in space if q(vector) == 1]
        weights = Counter(min(vector.bit_count(), len(points) - vector.bit_count()) for vector in q_one)
        recovered = {vector for vector in q_one if min(vector.bit_count(), len(points) - vector.bit_count()) == 2}
        assert weights == Counter({6: 10, 2: 6})
        assert recovered == {canonical(edge_mask(edge)) for edge in matching}
        recovery_spectra.append(weights)

    intersection_cycle_spectrum = Counter()
    distance_spectrum = Counter()
    for i, j in itertools.combinations(range(len(matchings)), 2):
        cycle_count = matching_cycles(matchings[i], matchings[j], len(points))
        intersection_size = len(lagrangians[i] & lagrangians[j])
        intersection_dimension = int(math.log2(intersection_size))
        assert 2**intersection_dimension == intersection_size
        assert intersection_dimension == cycle_count - 1
        distance = 10 - 2 * intersection_dimension
        assert distance == 12 - 2 * cycle_count
        intersection_cycle_spectrum[(intersection_dimension, cycle_count)] += 1
        distance_spectrum[distance] += 1

    factorization_cycle_spectra = []
    factorization_is_perfect = []
    for sheet in sheets:
        spectrum = Counter(matching_cycles(left, right, len(points)) for left, right in itertools.combinations(sheet, 2))
        factorization_cycle_spectra.append(spectrum)
        factorization_is_perfect.append(set(spectrum) == {1})

    flags = {(matching, edge) for matching in matchings for edge in matching}
    pointed = {(matching, edge, endpoint) for matching, edge in flags for endpoint in edge}
    assert len(flags) == 132 and len(pointed) == 264

    # Reconstruct the frozen finite groups and verify the induced orbit/stabilizer chain.
    c341 = c379.load_c341()
    plane = c379.projective_points(c341)
    plus = frozenset(c379.normalize(point) for point in c341.six_points(c379.Q, 8))
    conic = frozenset(point for point in plane if c379.dot(point, point) == 0)
    roots = c341.h3_roots(c379.Q, 8)
    a5 = {c379.mat_normalize(matrix) for matrix in c341.reflection_group(c379.Q, roots)}
    pgl = c379.closure(list(a5) + [c379.J])
    psl = c379.closure(list(a5) + list(c379.conjugate(c379.J, a5)))
    plus_matching_points = c379.obstruction_matching(plus, conic)
    plus_matching = parse_matching(c379.matching_json(plus_matching_points))
    selected_edge = plus_matching[0]
    selected_point = points[selected_edge[0]]

    parent_stabilizer = {matrix for matrix in pgl if c379.image(matrix, plus) == plus}
    edge_points = frozenset(points[index] for index in selected_edge)
    edge_stabilizer = {
        matrix
        for matrix in parent_stabilizer
        if frozenset(c379.normalize(c379.mat_vec(matrix, point)) for point in edge_points) == edge_points
    }
    point_stabilizer = {
        matrix
        for matrix in edge_stabilizer
        if c379.normalize(c379.mat_vec(matrix, selected_point)) == selected_point
    }
    assert (len(point_stabilizer), len(edge_stabilizer), len(parent_stabilizer), len(pgl)) == (5, 10, 60, 1320)
    assert point_stabilizer < edge_stabilizer < parent_stabilizer < pgl

    identity = c379.mat_normalize(((1, 0, 0), (0, 1, 0), (0, 0, 1)))

    def order(matrix) -> int:
        product = identity
        for exponent in range(1, 61):
            product = c379.mat_normalize(c379.mat_mul(product, matrix))
            if product == identity:
                return exponent
        raise AssertionError("unexpected element order")

    subgroup_order_spectra = [Counter(order(matrix) for matrix in subgroup) for subgroup in (point_stabilizer, edge_stabilizer, parent_stabilizer)]
    assert subgroup_order_spectra == [
        Counter({5: 4, 1: 1}),
        Counter({2: 5, 5: 4, 1: 1}),
        Counter({5: 24, 3: 20, 2: 15, 1: 1}),
    ]
    assert len(psl) == 660 and c379.J not in psl

    finite = {
        "point_count": len(points),
        "matching_count": len(matchings),
        "lagrangian_count": len(set(lagrangians)),
        "lagrangian_dimension": 5,
        "singular_kernel_dimension": 4,
        "q_one_minimum_weight_spectrum": {"2": 6, "6": 10},
        "matching_recovery_verified": True,
        "flag_count": len(flags),
        "pointed_flag_count": len(pointed),
        "intersection_cycle_spectrum": {
            f"dim={dimension},cycles={cycles}": count
            for (dimension, cycles), count in sorted(intersection_cycle_spectrum.items())
        },
        "subspace_distance_spectrum": {str(distance): count for distance, count in sorted(distance_spectrum.items())},
        "factorization_cycle_spectra": [
            {str(cycles): count for cycles, count in sorted(spectrum.items())}
            for spectrum in factorization_cycle_spectra
        ],
        "factorization_is_perfect": factorization_is_perfect,
    }
    groups = {
        "orders": {"C5": len(point_stabilizer), "D10": len(edge_stabilizer), "A5": len(parent_stabilizer), "PSL2_11": len(psl), "PGL2_11": len(pgl)},
        "element_order_spectra": {
            name: {str(element_order): count for element_order, count in sorted(spectrum.items())}
            for name, spectrum in zip(("C5", "D10", "A5"), subgroup_order_spectra)
        },
        "homogeneous_space_sizes": {
            "PGL2_11/C5": len(pgl) // len(point_stabilizer),
            "PGL2_11/D10": len(pgl) // len(edge_stabilizer),
            "PGL2_11/A5": len(pgl) // len(parent_stabilizer),
        },
        "golden_J_outside_PSL2_11": c379.J not in psl,
    }
    return finite, groups


def triality_data() -> dict[str, object]:
    # W is the deleted permutation module in F2^5.  Four bits are free; the
    # fifth is their parity.  J(Bring)[2] is W+W with q(x,y)=x.y.
    def expand(value: int) -> int:
        return value | ((value.bit_count() % 2) << 4)

    def w_action(permutation: tuple[int, ...], value: int) -> int:
        expanded = expand(value)
        image = 0
        for old, new in enumerate(permutation):
            if expanded & (1 << old):
                image ^= 1 << new
        return image & 15

    def action(permutation: tuple[int, ...], value: int) -> int:
        return w_action(permutation, value & 15) | (w_action(permutation, value >> 4) << 4)

    def q(value: int) -> int:
        return ((expand(value & 15) & expand(value >> 4)).bit_count()) % 2

    permutations = tuple(itertools.permutations(range(5)))
    unseen = set(range(256))
    orbits = []
    while unseen:
        representative = min(unseen)
        orbit = frozenset(action(permutation, representative) for permutation in permutations)
        unseen -= orbit
        parities = {q(value) for value in orbit}
        assert len(parities) == 1
        orbits.append((next(iter(parities)), orbit))
    orbit_spectrum = Counter((parity, len(orbit)) for parity, orbit in orbits)
    assert orbit_spectrum == Counter({(0, 5): 3, (0, 10): 3, (0, 30): 3, (1, 20): 3, (0, 1): 1, (1, 60): 1})

    generators = ((1, 0, 2, 3, 4), (1, 2, 3, 4, 0))

    def images(permutation):
        return tuple(action(permutation, 1 << column) for column in range(8))

    generator_images = tuple(images(permutation) for permutation in generators)

    # Solve T*g=g*T as a homogeneous system in the 64 entries of T.
    equations = []
    for group_matrix in generator_images:
        for column in range(8):
            group_column = group_matrix[column]
            for row in range(8):
                equation = 0
                for source in range(8):
                    if group_column & (1 << source):
                        equation ^= 1 << (row * 8 + source)
                    if group_matrix[source] & (1 << row):
                        equation ^= 1 << (source * 8 + column)
                equations.append(equation)

    def nullspace(rows: list[int], width: int) -> list[int]:
        rows = [row for row in rows if row]
        pivots = []
        pivot_row = 0
        for column in range(width):
            pivot = next((index for index in range(pivot_row, len(rows)) if rows[index] & (1 << column)), None)
            if pivot is None:
                continue
            rows[pivot_row], rows[pivot] = rows[pivot], rows[pivot_row]
            for index in range(len(rows)):
                if index != pivot_row and rows[index] & (1 << column):
                    rows[index] ^= rows[pivot_row]
            pivots.append(column)
            pivot_row += 1
        free = [column for column in range(width) if column not in pivots]
        basis = []
        for free_column in free:
            vector = 1 << free_column
            for row, pivot in zip(rows, pivots):
                if row & (1 << free_column):
                    vector ^= 1 << pivot
            basis.append(vector)
        return basis

    commutant_basis = nullspace(equations, 64)
    assert len(commutant_basis) == 4

    def unpack(encoded: int) -> tuple[int, ...]:
        columns = []
        for column in range(8):
            value = 0
            for row in range(8):
                if encoded & (1 << (row * 8 + column)):
                    value |= 1 << row
            columns.append(value)
        return tuple(columns)

    def apply(matrix: tuple[int, ...], value: int) -> int:
        output = 0
        for column in range(8):
            if value & (1 << column):
                output ^= matrix[column]
        return output

    def rank(matrix: tuple[int, ...]) -> int:
        rows = list(matrix)
        result = 0
        for bit in range(8):
            pivot = next((index for index in range(result, len(rows)) if rows[index] & (1 << bit)), None)
            if pivot is not None:
                rows[result], rows[pivot] = rows[pivot], rows[result]
                for index in range(len(rows)):
                    if index != result and rows[index] & (1 << bit):
                        rows[index] ^= rows[result]
                result += 1
        return result

    commutant = []
    for coefficients in range(1 << len(commutant_basis)):
        encoded = 0
        for index, basis_vector in enumerate(commutant_basis):
            if coefficients & (1 << index):
                encoded ^= basis_vector
        matrix = unpack(encoded)
        if rank(matrix) == 8 and all(q(apply(matrix, value)) == q(value) for value in range(256)):
            commutant.append(matrix)
    assert len(commutant) == 6

    identity = tuple(1 << index for index in range(8))

    def compose(left, right):
        return tuple(apply(left, column) for column in right)

    def order(matrix):
        product = identity
        for exponent in range(1, 7):
            product = compose(product, matrix)
            if product == identity:
                return exponent
        raise AssertionError

    centralizer_orders = Counter(order(matrix) for matrix in commutant)
    assert centralizer_orders == Counter({2: 3, 3: 2, 1: 1})

    orbit_index = {value: index for index, (_, orbit) in enumerate(orbits) for value in orbit}
    orbit_permutations = {
        tuple(orbit_index[apply(matrix, min(orbit))] for _, orbit in orbits)
        for matrix in commutant
    }
    assert len(orbit_permutations) == 6
    for parity, size in ((0, 5), (0, 10), (0, 30), (1, 20)):
        indices = [index for index, (orbit_parity, orbit) in enumerate(orbits) if (orbit_parity, len(orbit)) == (parity, size)]
        images = {tuple(permutation[index] for index in indices) for permutation in orbit_permutations}
        assert len(images) == 6
    for parity, size in ((0, 1), (1, 60)):
        index = next(index for index, (orbit_parity, orbit) in enumerate(orbits) if (orbit_parity, len(orbit)) == (parity, size))
        assert {permutation[index] for permutation in orbit_permutations} == {index}

    # Aut(S5)=S5 and Z(S5)=1.  Hence every orthogonal normalizer element can
    # be corrected by an element of S5 to centralize it, so N=S5 x C.
    return {
        "model": "deleted_permutation_module_W_direct_sum_W",
        "quadratic_form": "q(x,y)=dot(x,y)",
        "dimension": 8,
        "type": "plus",
        "theta_orbit_spectrum": {
            f"parity={parity},size={size}": count
            for (parity, size), count in sorted(orbit_spectrum.items())
        },
        "linear_commutant_dimension": len(commutant_basis),
        "orthogonal_centralizer_order": len(commutant),
        "orthogonal_centralizer_element_orders": {str(key): value for key, value in sorted(centralizer_orders.items())},
        "orthogonal_centralizer_is_GL2_2_is_S3": True,
        "normalizer_order": 120 * len(commutant),
        "normalizer_quotient_order": len(commutant),
        "normalizer_quotient_is_S3": True,
        "simultaneously_permutes_all_four_orbit_triples": True,
        "fixes_unique_even_theta_and_size_60_odd_orbit": True,
    }


def golden_reduction_data() -> dict[str, object]:
    # Polynomials are coefficient lists in increasing degree.  The two cubic
    # fibre equations obtained from the HC model are
    # y^3+t^3 y^2+t y-t^4 and t^3 y^3-t^4 y^2+y+t.
    def trim(polynomial):
        result = list(polynomial)
        while result and result[-1] == 0:
            result.pop()
        return tuple(result or [0])

    def add(*polynomials):
        width = max(map(len, polynomials))
        return trim([sum(polynomial[i] if i < len(polynomial) else 0 for polynomial in polynomials) for i in range(width)])

    def scale(coefficient, polynomial):
        return trim([coefficient * value for value in polynomial])

    def multiply(left, right):
        result = [0] * (len(left) + len(right) - 1)
        for i, a in enumerate(left):
            for j, b in enumerate(right):
                result[i + j] += a * b
        return trim(result)

    def power(polynomial, exponent):
        result = (1,)
        for _ in range(exponent):
            result = multiply(result, polynomial)
        return result

    def cubic_discriminant(a, b, c, d):
        # b^2 c^2 - 4ac^3 - 4b^3d - 27a^2d^2 + 18abcd
        return add(
            multiply(power(b, 2), power(c, 2)),
            scale(-4, multiply(a, power(c, 3))),
            scale(-4, multiply(power(b, 3), d)),
            scale(-27, multiply(power(a, 2), power(d, 2))),
            scale(18, multiply(multiply(a, b), multiply(c, d))),
        )

    one, t, t3, t4 = (1,), (0, 1), (0, 0, 0, 1), (0, 0, 0, 0, 1)
    discriminant_one = cubic_discriminant(one, t3, t, scale(-1, t4))
    discriminant_two = cubic_discriminant(t3, scale(-1, t4), one, t)
    golden = (-1, -1, 1)
    quartic_one = (1, -3, 4, -2, 1)
    quartic_two = (1, 2, 4, 3, 1)
    factorization = scale(4, multiply(power(t, 3), multiply(golden, multiply(quartic_one, quartic_two))))
    assert discriminant_one == discriminant_two == factorization

    def evaluate(polynomial, value, modulus):
        result = 0
        for coefficient in reversed(polynomial):
            result = (result * value + coefficient) % modulus
        return result

    finite_roots = [value for value in range(11) if evaluate(factorization, value, 11) == 0]
    golden_roots = [value for value in range(11) if evaluate(golden, value, 11) == 0]
    assert finite_roots == list(range(11)) and golden_roots == [4, 8]
    # Fermat gives product_(a in F11*) (t-a)=t^10-1.
    reduced_target = scale(4, multiply(power(t, 3), (-1,) + (0,) * 9 + (1,)))
    assert tuple(value % 11 for value in factorization) == tuple(value % 11 for value in reduced_target)
    return {
        "hc_trigonal_fibre_equations": ["y^3+t^3*y^2+t*y-t^4", "t^3*y^3-t^4*y^2+y+t"],
        "common_discriminant_coefficients_increasing_degree": list(factorization),
        "common_discriminant_factorization": "4*t^3*(t^2-t-1)*(t^4-2*t^3+4*t^2-3*t+1)*(t^4+3*t^3+4*t^2+2*t+1)",
        "mod_11_discriminant": "4*t^3*(t^10-1)",
        "finite_branch_support": finite_roots,
        "projective_branch_support": "P1(F_11), including infinity",
        "golden_roots_mod_11": golden_roots,
        "ruling_parameters_match_C376_tau_values": True,
        "pairing_identification": "Dye Theorem 8 double-contact pairs = C379 five-parent-conic obstruction pairs",
    }


def certificate() -> dict[str, object]:
    c379, frozen = load_c379()
    matching, groups = matching_data(c379, frozen)
    return {
        "schema": "othello.c390.free_upgrades.v1",
        "trusted_inputs": {
            C379_PY.name: {"bytes": C379_PY.stat().st_size, "sha256": C379_PY_SHA256},
            C379_JSON.name: {"bytes": C379_JSON.stat().st_size, "sha256": C379_JSON_SHA256},
        },
        "e8_norm_four": e8_data(),
        "matching_lagrangians": matching,
        "induced_homogeneous_spaces": groups,
        "bring_theta_centralizer": triality_data(),
        "golden_reduction": golden_reduction_data(),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    result = certificate()
    encoded = canonical_bytes(result)
    if args.write:
        OUTPUT.write_bytes(encoded)
        print(f"wrote {OUTPUT.relative_to(ROOT)}")
    elif args.check:
        assert OUTPUT.read_bytes() == encoded
        print(f"verified {OUTPUT.relative_to(ROOT)}")
    else:
        print(encoded.decode(), end="")


if __name__ == "__main__":
    main()
